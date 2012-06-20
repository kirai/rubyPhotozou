# -*- encoding : utf-8 -*-
require '../photozouAPI.rb' #TODO: how do I get rid of the "./../" ?
require 'rspec'

describe "PhotozouApiClass" do
 
  before :each do
    @photo = PhotozouB.new
  end

  describe "User Info" do

    before(:each) do
      @user_info = {
        :user_id => '2386319',
        :profile_url => 'http://photozou.jp/user/top/2386319',
        :nick_name => 'dd',
        :my_pic => 'http://photozou.jp/img/nophoto_70_mypic.gif',
        :photo_num => '11',
        :friends_num => '0'
      }
    end

    it "returns a hash of user info data" do
      user_info = Photozou.user_info( { :user_id => 2386319 } )
      user_info.should == @user_info
    end
  end


  it "should return album photos when calling photo_list" do
    q = { "type" => "album", "user_id" => USERID, "album_id" => '6712980', "limit" => 5 }
    photosXml        = @photo.photo_list_public(q)
    photosXml.should =~ /.*photo.*/ 
  end

  describe "GET requests" do

    it "should return photo information when calling photo_info" do
      q = { "photo_id" => 139780150 }
      #response = @photo.photo_info(q)
      response = $photozouApiLambda.call('photo_info', q)
      response.should =~ /.*photo_id.*/
    end

    it "should return user information when calling user_info" do
      q = { "user_id" => USERID }
      #response = $photozouApiLambda.call('user_info', q)
      #response = $user_info.call(q)
      response = $photozouApiLambdaHash['user_info'].call(q)
      response.should =~ /.*user_id.*/
    end
  end

end
