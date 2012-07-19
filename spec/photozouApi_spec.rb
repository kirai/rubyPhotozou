# -*- encoding : utf-8 -*-
require '../photozouAPI.rb' #TODO: how do I get rid of the "./../" ?
require 'rspec'

describe "PhotozouApiClass" do
 
  describe "User Info GET" do

    before(:each) do
      @user_info = {
        :user_id => USERID
      }
    end

    it "returns a hash of user_info data" do
      user_info = Photozou.user_info( { :user_id => USERID } )
      user_info['rsp']['info']['user_id'].should == @user_info['user_id']
    end

     #it "raises and exception when the parameters are not correct" do
     #   Photozou.user_info( { :bad_request_userrrr => 139780150 } ).should raise_error
     #end

  end

  describe "Photo Info GET. photo_info" do
     before(:each) do
       @photo_info = {
            :photo_id => PHOTOID,
            :copyright => 'creativecommons'
        }
     end
     
     it "returns a hash with photo_info data" do 
        photo_info = Photozou.photo_info( { :photo_id => PHOTOID } )
        photo_info['rsp']['info']['photo_id'].should == @photo_info['photo_id']
        photo_info['rsp']['info']['copyright'].should == @photo_info['copyright']
     end

     #it "raises and exception when the parameters are not correct" do
     #   Photozou.photo_info( { :bad_request_photo_id => 139780150 } ).should raise_error
     #end
  end

  describe "Photo List Public GET. photo_list_public" do
      it "returns a hash with photo list data" do
         args = { "type" => "album", 
                  "user_id" => USERID,
                  "album_id" => ALBUMID,
                  "limit" => '5' }
         photo_list = Photozou.photo_list_public(args)
         photo_list['rsp']['info']['photo_num'].should == args['limit'] 
      end
  end

  describe "Search Public GET. search_public" do
    it "return a hash with the search results" do
      args = { "keyword" => "tokyo" }
      response = Photozou.search_public(args)
      response.should_not be_empty
    end
  end

  describe "Photo Add POST. photo_add" do
    it "should upload a picture when sending correct paramters to photo_add" do
      pictureName = 'testpicture.jpg'
      pictureData = File.open(pictureName, "rb") {|io| io.read}

      args = {"album_id" => ALBUMID,
              "photo"    => pictureName}

      response = Photozou.photo_add(args)
      #puts response
      #response.should =~ /.*children.*/  
     end
  end

  describe "nop ユーザー認証 test. nop" do
    it "nop returns user_id if the user is logged in" do
      Photozou.nop['rsp']['info']['user_id'].should == USERID
    end
  end

  describe "User groups GET request. user_group" do
    it "should get the group_id corresponding to a user" do
      Photozou.user_group['rsp']['info']['user_group'][2]['group_id'].should == '0'
    end
  end

  describe "Delete a picture POST request. delete_picture" do
    it "should delete a picture" do
      pictureName = 'testpicture.jpg'
      pictureData = File.open(pictureName, "rb") {|io| io.read}

      args = {"album_id" => ALBUMID,
              "photo"    => pictureName}

      response = Photozou.photo_add(args)
      responseDelete = Photozou.photo_delete({"photo_id" => response['rsp']['photo_id']})
    end
  end
end
