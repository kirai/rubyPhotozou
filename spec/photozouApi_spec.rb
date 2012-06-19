# -*- encoding : utf-8 -*-
require '../photozouAPI.rb' #TODO: how do I get rid of the "./../" ?

describe "PhotozouApiClass" do
 
  before :each do
    @photo = Photozou.new
  end

  it "should return album photos when calling photo_list" do
    q = { "type" => "album", "user_id" => USERID, "album_id" => '6712980', "limit" => 5 }
    photosXml        = @photo.photo_list_public(q)
    photosXml.should =~ /.*photo.*/ 
  end

  it "should return photo information when calling photo_info" do
    q = { "photo_id" => 139780150 }
    #response = @photo.photo_info(q)
    response = $photozouApiLambda.call('photo_info', q)
    response.should =~ /.*photo_id.*/

  end


  it "should return user information when calling user_info" do
    q = { "user_id" => USERID }
    response = $photozouApiLambda.call('user_info', q)
    response.should =~ /.*user_id.*/

  end

end
