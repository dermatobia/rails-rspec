require 'spec_helper'

feature 'User browsing the website' do
  context "on homepage" do
    it "sees a list of recent posts titles" do
      p = Post.create(title: "Test Post 1", content: "content")

      visit root_path
      page.should have_content "Test Post 1"
    end

    it "can click on titles of recent posts and should be on the post show page" do
      p = Post.create(title: "Test Post 1", content: "content")

      visit root_path
      click_link "Test Post 1"
      page.should have_content "Test Post 1"
      page.should have_content "content"
    end
  end

  context "post show page" do
    it "sees title and body of the post" do
      p = Post.create(title: "Test Post 1", content: "content")

      visit post_path(p)
      page.should have_content "Test Post 1"
      page.should have_content "content"
    end
  end
end
