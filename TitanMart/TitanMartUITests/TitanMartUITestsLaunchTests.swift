let app = XCUIApplication()
app.activate()
app/*@START_MENU_TOKEN@*/.buttons["Electronics, Good, iPhone 12, $400, 4.9"]/*[[".buttons",".containing(.staticText, identifier: \"$400\").firstMatch",".containing(.staticText, identifier: \"iPhone 12\").firstMatch",".otherElements.buttons[\"Electronics, Good, iPhone 12, $400, 4.9\"]",".buttons[\"Electronics, Good, iPhone 12, $400, 4.9\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

let backButton = app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".navigationBars",".buttons.firstMatch",".buttons[\"Back\"]"],[[[-1,2],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
backButton.tap()

let scrollViewsQuery = app.scrollViews
let element = scrollViewsQuery/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.other, identifier: \"Vertical scroll bar, 4 pages\").firstMatch",".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
element.swipeUp()
element.swipeUp()
element.swipeDown()
element.swipeDown()
app/*@START_MENU_TOKEN@*/.buttons["Textbooks, Like New, Calculus Textbook, $45, 4.8"]/*[[".buttons.containing(.staticText, identifier: \"Calculus Textbook\").firstMatch",".otherElements.buttons[\"Textbooks, Like New, Calculus Textbook, $45, 4.8\"]",".buttons[\"Textbooks, Like New, Calculus Textbook, $45, 4.8\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

let element2 = scrollViewsQuery/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.other, identifier: \"Vertical scroll bar, 2 pages\").firstMatch",".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
element2.swipeUp()
backButton.tap()

let cartFillImage = app/*@START_MENU_TOKEN@*/.images["cart.fill"]/*[[".otherElements",".images[\"Shopping Cart\"]",".images[\"cart.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
cartFillImage.tap()
cartFillImage.tap()

let cartFillButton = app/*@START_MENU_TOKEN@*/.buttons["cart.fill"]/*[[".tabBars",".buttons[\"Cart\"]",".buttons[\"cart.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
cartFillButton.tap()

let houseFillButton = app/*@START_MENU_TOKEN@*/.buttons["house.fill"]/*[[".tabBars",".buttons[\"Browse\"]",".buttons[\"house.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
houseFillButton.tap()

let personFillButton = app/*@START_MENU_TOKEN@*/.buttons["person.fill"]/*[[".tabBars",".buttons[\"Profile\"]",".buttons[\"person.fill\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
personFillButton.tap()
houseFillButton.tap()
cartFillButton.tap()
houseFillButton.tap()
element.swipeUp()

let schoolSuppliesButton = app/*@START_MENU_TOKEN@*/.buttons["School Supplies, New, Science Goggles, $15, 4.7"]/*[[".buttons",".containing(.staticText, identifier: \"$15\").firstMatch",".containing(.staticText, identifier: \"Science Goggles\").firstMatch",".otherElements.buttons[\"School Supplies, New, Science Goggles, $15, 4.7\"]",".buttons[\"School Supplies, New, Science Goggles, $15, 4.7\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/
schoolSuppliesButton.tap()
schoolSuppliesButton.tap()
element2.swipeUp()
element2.swipeDown()
backButton.tap()
element.tap()
element.tap()
element.tap()
personFillButton.tap()
app/*@START_MENU_TOKEN@*/.buttons["Logout"]/*[[".buttons",".containing(.staticText, identifier: \"Logout\").firstMatch",".containing(.image, identifier: \"rectangle.portrait.and.arrow.right\").firstMatch",".otherElements.buttons[\"Logout\"]",".buttons[\"Logout\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()

let logoutStaticText = app/*@START_MENU_TOKEN@*/.staticTexts["Logout"]/*[[".buttons[\"Logout\"].staticTexts.firstMatch",".buttons.staticTexts[\"Logout\"]",".staticTexts[\"Logout\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
logoutStaticText.tap()
logoutStaticText.tap()
logoutStaticText.tap()
logoutStaticText.tap()
logoutStaticText.tap()
logoutStaticText.tap()
app/*@START_MENU_TOKEN@*/.buttons["Help & Support"]/*[[".buttons",".containing(.staticText, identifier: \"Help & Support\").firstMatch",".containing(.image, identifier: \"questionmark.circle\").firstMatch",".otherElements.buttons[\"Help & Support\"]",".buttons[\"Help & Support\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
backButton.tap()
app/*@START_MENU_TOKEN@*/.buttons["My Orders"]/*[[".buttons",".containing(.staticText, identifier: \"My Orders\").firstMatch",".containing(.image, identifier: \"bag.fill\").firstMatch",".otherElements.buttons[\"My Orders\"]",".buttons[\"My Orders\"]"],[[[-1,4],[-1,3],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
backButton.tap()
app/*@START_MENU_TOKEN@*/.staticTexts["Sell an Item"]/*[[".buttons[\"Sell an Item\"].staticTexts.firstMatch",".buttons.staticTexts[\"Sell an Item\"]",".staticTexts[\"Sell an Item\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
backButton.tap()
houseFillButton.tap()
XCUIDevice.shared.press(.home)
XCUIDevice.shared.press(.home)

let springboardApp = XCUIApplication(bundleIdentifier: "com.apple.springboard")
springboardApp.otherElements.element(boundBy: 101).tap()
//
//  TitanMartUITestsLaunchTests.swift
//  TitanMartUITests
//
//  Created by Elizsa Montoya on 10/22/25.
//

import XCTest

final class TitanMartUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
