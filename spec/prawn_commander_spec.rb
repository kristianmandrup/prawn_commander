require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe Howrah::Prawn::Commander do                 
  let (:doc)       { Prawn::Document.new(:page_size => "A4") }  

  before(:each) do
    @commander = Howrah::Prawn::Commander.new doc
  end

  context "clean commander" do    
    it "should have a prawn document" do
      @commander.prawn_document.should == doc
    end      

    context "issue 'move_down' prawn command" do
      it "should add 'move_down' to command stack" do        
        @commander.prawn_command(:move_down, 10)
        @commander.prawn_commands.first.should be_command(:move_down, 10)
      end          
    end

    context "issue 'go_down' prawn command" do
      it "should raise error and NOT add command to prawn command stack" do
        lambda { @commander.prawn_command(:go_down, 10) }.should raise_error                
        @commander.prawn_commands.first.should_not be_command(:go_down, 10)
      end
    end
  end
end
