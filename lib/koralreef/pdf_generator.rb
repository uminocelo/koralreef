# frozen_string_literal: true

require "prawn"

module Koralreef
  class PdfGenerator
    def create_pdf(image_paths, output_file = 'scraped_images.pdf')
      return nil if image_paths.empty?

      Prawn::Document.generate(output_file, page_layout: :portrait) do |pdf|
        image_paths.each_with_index do |image_path, index|
          pdf.start_new_page if index > 0
          img_width = pdf.bounds.width * 0.8

          begin
            pdf.image image_path, position: :center, width: img_width
            pdf.text "Image #{index + 1}", align: :center, size: 10
          rescue StandardError => _e
            pdf.text "Error including image: #{File.basename(image_path)}", align: :center, color: 'FF0000'
          end
        end
      end

      output_file
    end
  end
end
