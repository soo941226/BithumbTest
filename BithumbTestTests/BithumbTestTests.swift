//
//  BithumbTestTests.swift
//  BithumbTestTests
//
//  Created by kjs on 2022/01/17.
//

import XCTest
@testable import BithumbTest

class BithumbTestTests: XCTestCase {
    func test_transaction의_심볼이1개일때_message를구하면_nil이_아니다() throws {
        //given
        let transaction = WSTransactionRequester(symbols: [Symbol(orderCurrency: .ALL, paymentCurrency: .BTC)])

        //when
        let message = transaction.message

        //then
        XCTAssertNotNil(message)
    }

    func test_transaction의_심볼이1개초과일때_message를구하면_nil이_아니다() throws {
        //given
        let transaction = WSTransactionRequester(symbols: [
            Symbol(orderCurrency: .ALL, paymentCurrency: .BTC),
            Symbol(orderCurrency: .BTC, paymentCurrency: .KRW),
            Symbol(orderCurrency: .ETH, paymentCurrency: .KRW),
            Symbol(orderCurrency: .etc(something: "ABC"), paymentCurrency: .KRW),
            Symbol(orderCurrency: .BTC, paymentCurrency: .BTC),
            Symbol(orderCurrency: .ETH, paymentCurrency: .BTC)
        ])

        //when
        let message = transaction.message

        //then
        XCTAssertNotNil(message)
    }

    func test_transaction의_심볼이1개일때_메시지가JSON인지확인하면_참이다() throws {
        //given
        let transaction = WSTransactionRequester(symbols: [Symbol(orderCurrency: .ALL, paymentCurrency: .BTC)])
        guard let message = transaction.message else {
            XCTFail()
            return
        }
        
        //when
        let isJSON = JSONChecker().excute(with: message)

        //then
        XCTAssertTrue(isJSON)
    }

    func test_transaction의_심볼이1개초과일때_메시지가JSON인지확인하면_참이다() throws {
        //given
        let transaction = WSTransactionRequester(symbols: [
            Symbol(orderCurrency: .ALL, paymentCurrency: .BTC),
            Symbol(orderCurrency: .BTC, paymentCurrency: .KRW),
            Symbol(orderCurrency: .ETH, paymentCurrency: .KRW),
            Symbol(orderCurrency: .etc(something: "ABC"), paymentCurrency: .KRW),
            Symbol(orderCurrency: .BTC, paymentCurrency: .BTC),
            Symbol(orderCurrency: .ETH, paymentCurrency: .BTC)
        ])

        //when
        guard let message = transaction.message else {
            XCTFail()
            return
        }
        let isJSON = JSONChecker().excute(with: message)

        //then
        XCTAssertTrue(isJSON)
    }
}
