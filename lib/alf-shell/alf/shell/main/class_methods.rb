module Alf
  module Shell
    class Main
      module ClassMethods

        def relational_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
             cmd.include?(Alf::Operator::Relational) &&
            !cmd.include?(Alf::Operator::Experimental)
          }
          sort_operators(ops, sort_by_name)
        end

        def experimental_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Operator::Relational) &&
            cmd.include?(Alf::Operator::Experimental)
          }
          sort_operators(ops, sort_by_name)
        end

        def non_relational_operators(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Operator::NonRelational)
          }
          sort_operators(ops, sort_by_name)
        end

        def other_non_relational_commands(sort_by_name = false)
          ops = subcommands.select{|cmd| 
            cmd.include?(Alf::Command)
          }
          sort_operators(ops, sort_by_name)
        end

        private

        def sort_operators(ops, sort_by_name)
          sort_by_name ? ops.sort{|op1,op2| 
            op1.command_name.to_s <=> op2.command_name.to_s
          } : ops
        end

      end
      extend(ClassMethods)
    end # class Main
  end # module Shell
end # module Alf
