# -*- encoding : utf-8 -*-
require '../photozouAPI.rb' #TODO: how do I get rid of the "./../" ?
require 'rspec'

describe "PhotozouApiClass" do
 
  before :each do
    @photo = PhotozouB.new
  end

  describe "User Info GET" do

    before(:each) do
      @user_info = {
        :user_id => USERID,
        :profile_url => 'http://photozou.jp/user/top/' + USERID,
        :nick_name => 'dd',
        :my_pic => 'http://photozou.jp/img/nophoto_70_mypic.gif',
        :photo_num => '11',
        :friends_num => '0'
      }
    end

    it "returns a hash of user_info data" do
      user_info = Photozou.user_info( { :user_id => USERID } )
      user_info['user_id'].should == @user_info['user_id']
    end

     it "raises and exception when the parameters are not correct" do
        Photozou.photo_info( { :bad_request_userrrr => 139780150 } ).should raise_error

     end

  end


  describe "Photo Info GET" do
     before(:each) do
       @photo_info = {
            :photo_id => '139780150',
            :copyright => 'creativecommons'
        }
     end
     
     it "returns a hash with photo_info data" do 
        photo_info = Photozou.photo_info( { :photo_id => 139780150 } )
        photo_info['photo_id'].should == @photo_info['photo_id']
        photo_info['copyright'].should == @photo_info['copyright']

     end


     it "raises and exception when the parameters are not correct" do
        Photozou.photo_info( { :bad_request_photo_id => 139780150 } ).should raise_error

     end
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
         args = { "type" => "album", "user_id" => USERID, "album_id" => '6712980', "limit" => 5 }
         photo_list = Photozou.photo_list_public(args)
         photo_list[0][:photo_id].should == @photo_list[0][:photo_id]
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
