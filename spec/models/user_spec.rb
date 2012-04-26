# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean         default(FALSE)
#

require 'spec_helper'

describe User do

  before(:each) do
    @attr = {:name => 'Example User',
             :email => 'example@example.com',
             :password => 'foobar',
             :password_confirmation => 'foobar'
            }
  end


  it 'should create a new instance given a valid attriubte' do
    User.create!(@attr)
  end

  it 'should require a name' do
    no_name_user = User.new(@attr.merge(:name => ''))
    no_name_user.should_not be_valid
  end

  it 'should require a email' do
    no_name_user = User.new(@attr.merge(:email => ''))
    no_name_user.should_not be_valid
  end

  it 'should reject names that are too long' do
    long_name = 'a' * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it 'should accept valid email addresses' do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end

  it 'should reject invalid email addresses' do
    addresses = %w[user@foo,com THE_USER_foo.bar.org first.last@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end

  it 'should reject duplicated email addresses' do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  it 'should reject email addresses identical up to case' do
    upcase_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcase_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

  describe 'password' do

    before(:each) do
      @user = User.new(@attr)
    end

    it 'should have a password attribute' do
      User.new(@attr).should respond_to(:password)
    end

    it 'should have a password confirmation' do
      @user.should respond_to(:password_confirmation)
    end
  end

  describe 'password validation' do
    it 'should require a password' do
      User.new(@attr.merge(:password => '', :password_confirmation => '')).should_not be_valid
    end

    it 'should require a matching password confirmation' do
      User.new(@attr.merge(:password_confirmation => 'invalid')).should_not be_valid
    end

    it 'should reject short password' do
      short = 'a' * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it 'should reject long password' do
      long = 'a' * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

  describe 'password encryption' do
    before(:each) do
      @user = User.create(@attr)
    end

    it 'should have an encrypted password attribute' do
      @user.should respond_to('encrypted_password')
    end

    it 'should set the encrypted password attribute' do
      @user.encrypted_password.should_not be_blank
    end

    it 'should have salt' do
      @user.salt.should_not be_blank
    end

    describe 'has_password? method' do
      it 'should exists' do
        @user.should respond_to(:has_password?)
      end

      it 'should return true if the password match' do
        @user.has_password?(@attr[:password]).should be_true
      end

      it 'should return true if the password match' do
        @user.has_password?('123').should_not be_true
      end
    end

    describe 'authenticate method' do

      it 'should exists' do
        User.should respond_to(:authenticate)
      end

      it 'should return nil on email/password mismatch' do
        User.authenticate(@attr[:email], 'wrongpass').should be_nil
      end

      it 'should return nil for an email address with no user' do
        User.authenticate('bar@ffffff.com', @attr[:password]).should be_nil
      end

      it 'should return the user on email/password match' do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end

  describe 'admin attribute' do

    before(:each) do
      @user = User.create!(@attr)
    end

    it 'should respond to admin' do
      @user.should respond_to(:admin)
    end

    it 'should be not an admin by default' do
      @user.should_not be_admin
    end

    it 'should be convertible to an admin' do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end
end
