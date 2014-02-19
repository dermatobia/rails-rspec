# GREAT RESOURCE: https://github.com/jnicklas/capybara/blob/master/README.md
# http://rubydoc.info/github/jnicklas/capybara/master/Capybara/

require 'spec_helper'

feature 'Admin panel' do
  before {page.driver.browser.authorize 'geek', 'jock'}

  context "on admin homepage" do
    it "can see a list of recent posts" do
      Post.create(title:"Test Post 1", content: "content")
      Post.create(title:"Test Post 2", content: "content")
      visit admin_posts_url

      page.should have_content("Test Post 1")
      page.should have_content("Test Post 2")

    end

    it "can edit a post by clicking the edit link next to a post" do
      Post.create(title:"Test Post 1", content: "content")
      visit admin_posts_url
      click_link "Edit"
      page.should have_content "Edit Test Post 1"
      fill_in "post[content]", :with => "edited content" # note that the name for fill in is the name attribute for the field
      click_button "Save"
      page.should have_content "edited content"

    end

    it "can delete a post by clicking the delete link next to a post" do
      Post.create(title:"Test Post 1", content: "content")
      visit admin_posts_url
      click_link "Delete"
      expect(Post.first).to eq(nil)
    end

    it "can create a new post and view it" do
       visit new_admin_post_url
       expect {
         fill_in 'post_title',   with: "Hello world!"
         fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
         page.check('post_is_published')
         click_button "Save"
       }.to change(Post, :count).by(1)

       page.should have_content "Published: true"
       page.should have_content "Post was successfully saved."
     end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      p = Post.create(title:"Test Post 1", content: "content", is_published: true)
      visit edit_admin_post_path(p)
      uncheck("post[is_published]")
      click_button "Save"
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do
    it "can visit a post show page by clicking the title" do
      p = Post.create(title:"Test Post 1", content: "content")
      visit admin_posts_url
      click_link "Test Post 1"
      page.should have_content "Test Post 1"
    end
    it "can see an edit link that takes you to the edit post path" do
      p = Post.create(title:"Test Post 1", content: "content")
      visit admin_post_path(p)
      page.has_link?("Edit post")
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      p = Post.create(title:"Test Post 1", content: "content")
      visit admin_post_path(p)
      click_link "Admin welcome page"
      page.should have_content("Welcome to the admin panel!")
    end
  end
end
