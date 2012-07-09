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
      user_info['user_id'].should == @user_info['user_id']
    end

     #it "raises and exception when the parameters are not correct" do
     #   Photozou.user_info( { :bad_request_userrrr => 139780150 } ).should raise_error
     #end

  end

  describe "Photo Info GET" do
     before(:each) do
       @photo_info = {
            :photo_id => PHOTOID,
            :copyright => 'creativecommons'
        }
     end
     
     it "returns a hash with photo_info data" do 
        photo_info = Photozou.photo_info( { :photo_id => PHOTOID } )
        photo_info['photo_id'].should == @photo_info['photo_id']
        photo_info['copyright'].should == @photo_info['copyright']
     end

     #it "raises and exception when the parameters are not correct" do
     #   Photozou.photo_info( { :bad_request_photo_id => 139780150 } ).should raise_error
     #end
  end

  describe "Photo List Public GET. photo_list_public" do
      before(:each) do
        @photo_list = {
          0 => {:photo_id => "140049756",
                :album_id => "6712980" },
          1 => {:photo_id => "139994143",
                :album_id => "139994143" } 
        }
      end
    
      it "returns a hash with photo list data" do
         args = { "type" => "album", 
                  "user_id" => USERID,
                  "album_id" => ALBUMID,
                  "limit" => 5 }
         photo_list = Photozou.photo_list_public(args)
         #photo_list[0][:photo_id].should == @photo_list[0][:photo_id]
      end
  end

  describe "Search Public GET. search_public" do
    before(:each) do
      @search_results = {}
    end
   
    #TODO improve this test, make it more specific 
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

  describe "nop ユーザー認証 test" do
    it "nop returns user_id if the user is logged in" do
       Photozou.nop.should == USERID
    end
  end

  describe "user_group" do
    it "should get the group_id corresponding to a user" do
      Photozou.user_group['rsp']['info']['user_group'][2]['group_id'].should == '0'
    end
  end

  describe "Transform XML results to hash" do
     # before (:each) do
     #   @response = Photozou.xml_to_hash open("photozou_search_public_results.xml").read
     # end

     # it "returns a hash with the correct photo_num" do
     #   @response[:photo_num].should == 100
     # end

     #it "returns a hash with an array of photos" do
     #   @response[:photos].count.should == 100
     # end
    
     #it "returns a hash for each photo in :photos" do
     #   photo_hash_keys = [:photo_id, :user_id, :album_id, :photo_title, :date, :url, :original_imag_url]
      #  photo_hash_keys.each {|key| @response[:photos][11].has_key?(key).should be_true }
      #end
  end

end
