# frozen_string_literal: true

require 'selenium-webdriver'
require 'nokogiri'
require 'webdrivers/chromedriver'
require 'down'
require 'fileutils'
require 'uri'

module Koralreef
  class Scraper
    attr_reader :driver, :downloaded_images

    def initialize(headless: true)
      options = Selenium::WebDriver::Chrome::Options.new
      options.add_argument("--headless") if headless
      options.add_argument("--disable-gpu")
      options.add_argument("--no-sandbox")
      options.add_argument("--disable-dev-shm-usage")

      @driver = Selenium::WebDriver.for(:chrome, options:)
      @driver.manage.timeouts.implicit_wait = 10 # in seconds

      @image_dir = File.join(Dir.tmpdir, "image_scraper_#{Time.now.to_i}")
      FileUtils.mkdir_p(@image_dir) unless Dir.exist?(@image_dir)
      @downloaded_images = []
    end

    def navigate_to(url)
      @driver.navigate.to(url)
      @current_url = url
    end

    def wait_for_images(selector, timeout = 10)
      wait = Selenium::WebDriver::Wait.new(timeout:)
      wait.until { !@driver.find_elements(css: selector).empty? }
    end

    def scrape_images(css_selector)
      doc = Nokogiri::HTML(@driver.page_source)
      image_elements = doc.css(css_selector)

      image_urls = image_elements.map { |img| img['src'] }.compact

      image_urls.map! do |url|
        if url.start_with?('http')
          url
        elsif url.start_with?('//')
          "https:#{url}"
        elsif url.start_with?('/')
          uri = URI.parse(@driver.current_url)
          "#{uri.scheme}://#{uri.host}#{url}"
        else
          uri = URI.parse(@driver.current_url)
          base_path = uri.path.split("/")[0..-2].join("/") + "/"
          "#{uri.scheme}://#{uri.host}#{base_path}#{url}"
        end
      end

      image_urls
    end

    def download_images(image_urls)
      image_urls.each_with_index do |url, index|
        begin
          tempfile = Down.download(url)

          ext = File.extname(tempfile.path)
          ext = ".jpg" if ext.empty?

          filename = File.join(@image_dir, "image_#{index}#{ext}")
          FileUtils.mv(tempfile.path, filename)

          @downloaded_images << filename
        rescue StandardError => e
          puts "Error downloading image #{url}: #{e.message}"
        end
      end

      @downloaded_images
    end

    def cleanup
      FileUtils.rm_rf(@image_dir) if Dir.exist?(@image_dir)
    end

    def close
      @driver.quit
      cleanup
    end
  end
end
