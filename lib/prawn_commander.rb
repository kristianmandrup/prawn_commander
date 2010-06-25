module Prawn
  class Commander      
    attr_accessor :prawn_document, :prawn_commands, :options
  
    def initialize(prawn_doc = nil, options = {:dry_run => true})
      @prawn_document = prawn_doc
      @prawn_commands = []
      @options = options
    end

    def prawn_commands(&block)                                       
      ctx = @prawn_commands
      if block
        block.arity < 1 ? ctx.instance_eval(&block) : block.call(ctx)
      end            
      ctx
    end
    
    def raw_prawn_commands
      raw_commands = []
      prawn_commands.each do |command|
        args = command[:args].size == 1 ? command[:args][0] : command[:args]          
        # arg_str = args
        arg_str = case args 
          when Array
            args.map{|a| a.inspect}.join(',')
          else
            args
        end
        raw_commands << "#{command[:method]} #{arg_str}"
      end
      raw_commands
    end

    def print_raw_prawn_commands
      puts raw_prawn_commands.join("\n")
    end
  
    def prawn_command(method, *args, &block)
      raise "#{method} is not a valid prawn command on a prawn document" if !valid_prawn_command?(method) 
      add_command(method, args.dup, block != nil)

      # make clone of command to ensure the original is not in any way modified internally by prawn  
      cmd = Marshal.load( Marshal.dump(prawn_commands.last) ) 
      document_execute cmd if prawn_document
    end

    protected

    def test_doc
      @test_doc ||= Prawn::Document.new      
    end

    def document_execute cmd
      puts prawn_document
      prawn_document.send cmd[:method], *cmd[:args] if !options[:dry_run] 
    end     
    
    def valid_prawn_command?(method)
      test_doc.respond_to? method      
    end
        
    def add_command(method, args, has_block)
      cmd = command(method, args, has_block)
      prawn_commands << cmd.dup
    end            
    
    def command(method, args, has_block)
      cmd = {:method => method}
      cmd.merge! :block => has_block if has_block
      cmd.merge! :args => args if !args.flatten.empty?
      cmd 
    end
  end
end

