module CompanyHelper
  def kind_options
    direct_business_options = [
      ["Channel Partner"],
      ["Cisco"],
      ["Commercial / Enterprise"],
      ["Distributor"],
      ["Federal"],
      ["SLED"]
    ]

    indirect_business_options = [
      ["CLP (Cisco Learning Partner)"],
      ["Seat Reseller"]
    ]

    deprecated_options = [
      ['Direct Customer'],
      ['Service Provider'],
      ['Training Resell Partner'],
      ['Vendor'],
      ['VMware']
    ]

    grouped_options = {}

    grouped_options["Direct Business"]   = direct_business_options.map { |e| [e[0], e[0]] }
    grouped_options["Indirect Business"] = indirect_business_options.map { |e| [e[0], e[0]] }

    if @company && deprecated_options.include?([@company.kind])
      grouped_options["Deprecated (Do Not Use)"] = deprecated_options.map { |e| [e[0], e[0]] }
    end
    
    selected_kind = @company.present? ? @company.kind : nil
    grouped_options_for_select(grouped_options, selected_kind)
  end

  def direct_indirect_kinds
    ["Channel Partner",
     "Cisco",
     "Commercial / Enterprise",
     "Distributor",
     "Federal",
     "SLED",
     "CLP (Cisco Learning Partner)",
     "Seat Reseller"
    ]
  end

  def industry_code_options
    [
      ["10 Automotive"],
      ["11 Agriculture, Forestry, Fishing and Hunting"],
      ["21 Mining, Quarrying, and Oil and Gas Extraction"],
      ["22 Utilities"],
      ["23 Construction"],
      ["31 Manufacturing"],
      ["32 Finance/Banking"],
      ["42 Wholesale Trade"],
      ["44 Retail Trade"],
      ["48 Transportation and Warehousing"],
      ["51 Information"],
      ["52 Finance and Insurance"],
      ["53 Real Estate and Rental and Leasing"],
      ["54 Professional, Scientific, and Technical Services"],
      ["55 Management of Companies and Enterprises"],
      ["56 Administrative and Support and Waste Management and Remediation Services"],
      ["61 Educational Services"],
      ["62 Health Care and Social Assistance"],
      ["71 Arts, Entertainment, and Recreation"],
      ["72 Accommodation and Food Services"],
      ["81 Other Services (except Public Administration)"],
      ["92 State, Local and Gov., Public Administration"]
    ]
  end
  
  def companies_amount companies, opportunities
    companies.map do|company| 
      Opportunity.get_company_total_amount(opportunities, company.id)
    end
  end

  def delimiter_companies_amount companies, opportunities
    companies.map do|company| 
      total_amount = Opportunity.get_company_total_amount(opportunities, company.id)
      "$#{number_with_delimiter(total_amount)}"
    end
  end

  def opportunities_amount_for_kinds opportunities
    direct_indirect_kinds.map{|kind| sum_of(opportunities.for_company_kind(kind), 'amount')} 
  end

end
