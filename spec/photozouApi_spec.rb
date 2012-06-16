# -*- encoding : utf-8 -*-
require '../photozouAPI.rb' #TODO: how do I get rid of the "./../" ?

describe "PhotozouApiClass" do
 
  before :each do
    @photo = Photozou.new
  end

  it "should return album photos when calling photo_list" do
    q = { "type" => "album", "user_id" => USERID, "album_id" => '6712980', "limit" => 5 }
    photosXml        = @photo.photo_list(q, 'photo_list_public')
    photosXml.should =~ /.*photo.*/ 
  end

end
