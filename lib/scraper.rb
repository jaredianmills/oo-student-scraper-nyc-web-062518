require "nokogiri"
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = File.read(index_url)
    students = Nokogiri::HTML(html)
    array_of_student_hashes = []
    students.css(".roster-cards-container .student-card").each do |student|
      student_hash = {
      name: student.css("h4.student-name").text,
      location: student.css(".student-location").text,
      profile_url: student.css("a").attribute("href").value
      }
      array_of_student_hashes << student_hash
    end
    array_of_student_hashes
  end

  def self.scrape_profile_page(profile_url)
    html = File.read(profile_url)
    student = Nokogiri::HTML(html)

    student_info = {
      profile_quote: student.css(".profile-quote").text,
      bio: student.css(".bio-content p").text
    }

    student.css(".social-icon-container a").each do |link|
      if link.attribute("href").value.include?("linkedin")
        student_info[:linkedin] = link.attribute("href").value
      elsif link.attribute("href").value.include?("github")
        student_info[:github] = link.attribute("href").value
      elsif link.attribute("href").value.include?("twitter")
        student_info[:twitter] = link.attribute("href").value
      else
        student_info[:blog] = link.attribute("href").value
      end
    end
    student_info
  end

end

Scraper.scrape_index_page("./fixtures/student-site/index.html")
