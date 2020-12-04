import Foundation

enum Field: String, CaseIterable {
    case birthYear = "byr"
    case issueYear = "iyr"
    case expirationYear = "eyr"
    case height = "hgt"
    case hairColor = "hcl"
    case eyeColor = "ecl"
    case passportID = "pid"
    case countryID = "cid"

    static var requiredFields: [Field] { [.birthYear, .issueYear, .expirationYear, .height, .hairColor, .eyeColor, .passportID] }

    var pattern: String {
        switch self {
        case .birthYear:
            return "^(19[2-9][0-9]|200[0-2])$"
        case .issueYear:
            return "^(20[1][0-9]|2020)$"
        case .expirationYear:
            return "^(20[2][0-9]|2030)$"
        case .height:
            return "^(1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in)$"
        case .hairColor:
            return "^#([0-9a-f]{6})$"
        case .eyeColor:
            return "^(amb|blu|brn|gry|grn|hzl|oth)$"
        case .passportID:
            return #"^(\d{9})$"#
        case .countryID:
            return ".*"
        }
    }
}

let path = Bundle.main.path(forResource: "Input", ofType: "txt")!
let data = FileManager.default.contents(atPath: path)!

let input = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
let rawPassports = input?.components(separatedBy: "\n\n")

let passports = rawPassports?.map { rawPassport -> [String: String] in
    // Split each passport data into components separated by whitespace
    let components = rawPassport.components(separatedBy: .whitespacesAndNewlines)
    // Each key value pair is colon delimited, split each into pairs and store them in a dictionary
    return components.reduce(into: [:]) { dictionary, component in
        let pair = component.components(separatedBy: ":")
        dictionary[pair[0]] = pair[1]
    }
}

// MARK: - Validation

/// Verifies that all required fields are present on a passport. No additional validation is done on the values of the fields
func hasRequiredFields(passport: [String: String]) -> Bool {
    let fields = Set(Field.requiredFields.map { $0.rawValue })
    // Only proceed if all required fields are present
    return fields.isSubset(of: passport.keys)
}

/// Verifies that the passport is completely valid, ensuring that all required fields are present and that the values associated with those fields are valid
func isValidPassport(passport: [String: String]) -> Bool {
    guard hasRequiredFields(passport: passport) else { return false }

    // Ensure that all required fields are met
    var isPassportValid = true
    Field.requiredFields.forEach { field in
        guard let value = passport[field.rawValue], value.range(of: field.pattern, options: .regularExpression) != nil else {
            isPassportValid = false
            return
        }
    }

    return isPassportValid
}

// MARK: - Exercise

let partOnePassports = passports?.filter { hasRequiredFields(passport: $0) }
partOnePassports?.count

let partTwoPassports = passports?.filter { isValidPassport(passport: $0) }
partTwoPassports?.count
