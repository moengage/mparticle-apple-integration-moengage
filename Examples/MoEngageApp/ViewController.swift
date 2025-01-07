//
//  ViewController.swift
//  MoEngageApp
//
//  Created by Soumya Ranjan Mahunt on 04/09/24.
//

import UIKit
import AdSupport
import AppTrackingTransparency
import mParticle_Apple_SDK

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    lazy var mPartcle = MParticle.sharedInstance()

    // Actions
    lazy var rows: [(String, () -> Void)] = [
        ("Log In", { [unowned self] in
            var identityRequest = MPIdentityApiRequest.withEmptyUser()
            identityRequest.customerId = "Soumya"
            self.mPartcle.identity.login(identityRequest) { result, error in
                if let error = error {
                    print("Login Failed(\(error)): \"\(error.localizedDescription)\"")
                }
                print("Login result: \(String(describing: result))")
            }
        }),
        ("Set Alias", { [unowned self] in
            var identityRequest = MPIdentityApiRequest.withEmptyUser()
            identityRequest.setIdentity("SoumyaAlt", identityType: .alias)
            self.mPartcle.identity.modify(identityRequest) { result, error in
                if let error = error {
                    print("Set Alias Failed(\(error)): \"\(error.localizedDescription)\"")
                }
                print("Set Alias result: \(String(describing: result))")
            }
        }),
        ("Set Phone Number", { [unowned self] in
            var identityRequest = MPIdentityApiRequest.withEmptyUser()
            identityRequest.setIdentity("9999999999", identityType: .mobileNumber)
            self.mPartcle.identity.modify(identityRequest) { result, error in
                if let error = error {
                    print("Set Phone Number Failed(\(error)): \"\(error.localizedDescription)\"")
                }
                print("Set Phone Number result: \(String(describing: result))")
            }
        }),
        ("Set Gender", { [unowned self] in
            self.mPartcle.identity.currentUser?.setUserAttribute(mParticleUserAttributeGender, value: "M")
        }),
        ("Set LastName", { [unowned self] in
            self.mPartcle.identity.currentUser?.setUserAttribute(mParticleUserAttributeLastName, value: "Mahunt")
        }),
        ("Set FirstName", { [unowned self] in
            self.mPartcle.identity.currentUser?.setUserAttribute(mParticleUserAttributeFirstName, value: "Soumya")
        }),
        ("Set Email", { [unowned self] in
            var identityRequest = MPIdentityApiRequest.withEmptyUser()
            identityRequest.email = "foo@example.com"
            self.mPartcle.identity.modify(identityRequest) { result, error in
                if let error = error {
                    print("Set Email Failed(\(error)): \"\(error.localizedDescription)\"")
                }
                print("Set Email result: \(String(describing: result))")
            }
        }),
        ("Set IDFA", { [unowned self] in
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    print("ADTracking status: \"\(status)\"")
                    self.mPartcle.setATTStatus(.init(rawValue: status.rawValue) ?? .notDetermined, withATTStatusTimestampMillis: nil)
                    switch status {
                    case .authorized:
                        var identityRequest = MPIdentityApiRequest.withEmptyUser()
                        identityRequest.setIdentity(ASIdentifierManager.shared().advertisingIdentifier.uuidString, identityType: .iosAdvertiserId)
                        self.mPartcle.identity.modify(identityRequest) { result, error in
                            if let error = error {
                                print("Set IDFA Failed(\(error)): \"\(error.localizedDescription)\"")
                            }
                            print("Set IDFA result: \(String(describing: result))")
                        }
                    default:
                        break
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }),
        ("Set Birthday", { [unowned self] in
            guard
                var currentUser = mPartcle.identity.currentUser
            else {
                print("Current user not present")
                return
            }
            currentUser.setUserAttribute("$Birthday", value: Date())
            currentUser.setUserAttribute("$BirthdayStr", value: self.getFormattedDate())
            currentUser.setUserAttribute("USER_ATTRIBUTE_USER_BDAY", value: Date())
        }),
        ("Set ISO birthday", {  }),
        ("Set ISO date", {  }),
        ("Set Location", { [unowned self] in
            self.mPartcle.location = .init(latitude: 12.9716, longitude: 77.5946)
        }),
        ("Set User Attributes", { [unowned self] in
            guard
                var currentUser = mPartcle.identity.currentUser
            else {
                print("Current user not present")
                return
            }
            currentUser.setUserAttribute("date", value: Date())
            currentUser.setUserAttribute("location", value: CLLocation(latitude: 12.9716, longitude: 77.5946))
            currentUser.setUserAttribute("top_region", value: "Europe")
            currentUser.setUserAttribute("trips_booked", value: 1)
            currentUser.setUserAttribute("done_trips", value: true)
            currentUser.setUserAttribute("spent_amount", value: 3.1416)
            currentUser.setUserAttribute("array_bool", value: [true, false, true])
            currentUser.setUserAttribute("array_int", value: [5, -2, 3])
            currentUser.setUserAttribute("array_double", value: [5.45, -2, 3.1416])
            currentUser.setUserAttributeList("destinations", values: ["Rome", "San Juan", "Denver"])
            currentUser.setUserAttribute("obj", value: ["key": "value", "array_bool": [true, false, true], "array_int": [5, -2, 3], "array_double": [5.45, -2, 3.1416]])
            currentUser.setUserAttribute("array_obj", value: [["key": "value", "array_bool": [true, false, true], "array_int": [5, -2, 3], "array_double": [5.45, -2, 3.1416]], ["key": "value", "array_bool": [true, false, true], "array_int": [5, -2, 3], "array_double": [5.45, -2, 3.1416]]])
        }),
        ("Track Events", { [unowned self] in
            guard
                var event = MPEvent(name: "mParticle_123", type: .other)
            else {
                print("Event creation failed")
                return
            }
            event.customAttributes = [
                "dupe":  "default",
                "general":  "value",
                "audioPlayed":  "Dangerous",
                "artist":  "David Garrett",
                "testDate":  Date(),
                "testDate2":  self.getFormattedDate(),
                "int": 12,
                "double": 3.1416,
                "bool": true,
                "arr_int": [-13, 12, 0],
                "arr_double": [-1.3, 12, 3.1416],
                "arr_bool": [false, true, true],
                "arr_str": ["string", "test", "dummy"],
            ]
            self.mPartcle.logEvent(event)
        }),
        ("Track Commerce Event", { [unowned self] in
            // Product
            let product = MPProduct(name: "productName", sku: "productSKU", quantity: 2, price: 2)
            product.category = "productCategory"
            product.couponCode = "productCouponCode"
            product.position = 20
            product.unitPrice = 2.0
            product.quantity = 5.0
            product.brand = "productBrand"
            product.variant = "productVariant"
            product.setUserDefinedAttributes(["customAttrKey": "customAttrValue"])
            // Transaction Attributes
            let tAttr = MPTransactionAttributes()
            tAttr.transactionId = "customTransactionId_\(DispatchTime.now().uptimeNanoseconds)"
            // Event
            let event = MPCommerceEvent(action: .addToCart, product: product)
            event.currency = "inr"
            event.transactionAttributes = tAttr
            event.customAttributes = [
                "dupe":  "default",
                "general":  "value",
                "audioPlayed":  "Dangerous",
                "artist":  "David Garrett",
                "testDate":  Date(),
                "testDate2":  self.getFormattedDate(),
                "int": 12,
                "double": 3.1416,
                "bool": true,
                "arr_int": [-13, 12, 0],
                "arr_double": [-1.3, 12, 3.1416],
                "arr_bool": [false, true, true],
                "arr_str": ["string", "test", "dummy"],
            ]
            self.mPartcle.logEvent(event)
        }),
        ("Flush Data", { [unowned self] in
            self.mPartcle.upload()
        }),
        ("Reset User", { [unowned self] in
            self.mPartcle.identity.logout { result, error in
                if let error = error {
                    print("Set Email Failed(\(error)): \"\(error.localizedDescription)\"")
                }
                print("Set Email result: \(String(describing: result))")
            }
            // exluding the identity request from any IDSync API is the same as invoking the following:
            // self.mPartcle.identity.logout(MPIdentityApiRequest.withEmptyUser())  { result, error in
            //     if let error = error {
            //         print("Set Email Failed(\(error)): \"\(error.localizedDescription)\"")
            //     }
            //     print("Set Email result: \(String(describing: result))")
            // }
        }),
        ("Opt in", { [unowned self] in
            self.mPartcle.optOut = false
        }),
        ("Opt out", { [unowned self] in
            self.mPartcle.optOut = true
        })
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        print("MoEngage mParticle Kit Instance: \(String(describing: mPartcle.kitInstance(1167)))")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Start location tracking
        // mPartcle.beginLocationTracking(kCLLocationAccuracyThreeKilometers, minDistance: 1000)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop location tracking
        // mPartcle.endLocationTracking()
    }

    func getFormattedDate() -> String {
        let format = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: Date())
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell {
            cell.titleLabel.text = rows[indexPath.row].0
            return cell
        }
        return UITableViewCell()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rows[indexPath.row].1()
    }
}
