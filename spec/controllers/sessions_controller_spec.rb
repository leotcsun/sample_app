require 'spec_helper'

describe SessionsController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "should have the right title" do
    it "should be successful" do
      get 'new'
      response.should have_selector('title', :content => "#{@base_title} | Sign in")
    end
  end

end
