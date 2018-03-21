module CompanyHelper
  def kind_options
    new_options = [
      ["Channel Partner"],
      ["Cisco"],
      ["Commercial / Enterprise"],
      ["Distributor"],
      ["Federal"],
      ["SLED"]
    ]

    old_options = [
      ['Direct Customer'],
      ['Service Provider'],
      ['Training Resell Partner'],
      ['Vendor'],
      ['VMware']
    ]           

    if @company && old_options.include?([@company.kind])
      grouped_options = {}
      grouped_options["Active (Select One)"] = new_options.map {|e| [e[0] + ' (Active - SELECT ONE)', e[0]]}
      grouped_options["Deprecated (Do Not Use)"] = old_options.map {|e| [e[0] + ' (Depreciated - DO NOT USE)', e[0]]}
      return grouped_options_for_select(grouped_options)
    end

    return new_options
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
end
