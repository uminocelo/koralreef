# frozen_string_literal: true

require_relative 'koralreef/version'
require_relative 'koralreef/scraper'
require_relative 'koralreef/pdf_generator'

module Koralreef
  class Error < StandardError; end

  def self.run(url:, selector:, output_file: 'scraped_images.pdf', headless: true)
    scraper = Koralreef::Scraper.new(headless: headless)

    begin
      scraper.navigate_to(url)
      scraper.wait_for_images(selector)
      image_urls = scraper.scrape_images(selector)
      image_files = scraper.download_images(image_urls)

      pdf_generator = Koralreef::PdfGenerator.new
      pdf_file = pdf_generator.create_pdf(image_files, output_file)

      pdf_file
    rescue StandardError => e
      raise Error, "Scraping failed: #{e.message}"
    ensure
      scraper.close
    end
  end
end
