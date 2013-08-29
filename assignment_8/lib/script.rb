#===================================================================
#Script				= script.rb
#===================================================================
#Description		= "Verification of account and balance data"
#Name				= "Lusine Barseg"
#Email				= "bars.lucy@gmail.com"
#====================================================================

require 'csv'

account = ARGV[0]			# capturing the first command-line argument
balance = ARGV[1]			# capturing the second command-line argument
report = "report.txt"		# output file

due_date = "2007/10/23"

account_file = File.join('./etc', account)		# defining the path for the input
balance_file = File.join('./etc', balance)		# defining the path for the input
report_file = File.join('./report', report)		# defining the path for the output

csv_account = CSV.read(account_file)			# parsing a csv file
csv_balance = CSV.read(balance_file)			# parsing a csv file

overdue = []									# array for problem accounts 
not_found = []									# array for accounts from the balance sheet that don't have corresponding records on the accounts sheet 

csv_balance.each do |bal_record|				# taking a record from the balance sheet 
	if (bal_record[0] != "id")
		acc_number = bal_record[1]
		balance = bal_record[2]
		balance_due = bal_record[3]
		c = 0
		csv_account.each do |acc_record|		# finding a corresponding record on the accounts sheet
			if (acc_number == acc_record[3])
				c=1
				flag = acc_record[4]
				re = /(\d{1,2})\/(\d{1,2})\/(\d{4})/	# regex for a date	
				balance_due.match re
				s = $3.to_s + "/" + $1.to_s + "/" + $2.to_s		# extracting the date from the balance_due field
				if (balance != "0") and ((Date.parse(s) < Date.parse(due_date)) and (flag == "0" or flag == nil ) )
				overdue << [acc_record[0], acc_record[1], acc_record[3], bal_record[2], bal_record[3], acc_record[4]].join(', ')
				end
				if (balance != "0") and ((Date.parse(s) >= Date.parse('2007/10/23')) and (flag == "1" ) )
				overdue << [acc_record[0], acc_record[1], acc_record[3], bal_record[2], bal_record[3], acc_record[4]].join(', ')
				end
				if ((balance == "0") and (flag == "1" ) )
				overdue << [acc_record[0], acc_record[1], acc_record[3], bal_record[2], bal_record[3], acc_record[4]].join(', ')
				end
			end
		end
		if c == 0
			not_found << bal_record
		end
	end
end


File.open(report_file, "w") do |write|		# opening a text file to output
	
	write << "=============================================================================\n"
	write << "The following people have their overdue value not properly set\n\n"
	overdue.each {|record|
	write << record + "\n"
	}
	write << "\n=============================================================================\n"
	write << "The following people have not been found in the accounts list\n\n"
	not_found.each {|record|
	write << record.inspect
	write << "\n"
	}
end










