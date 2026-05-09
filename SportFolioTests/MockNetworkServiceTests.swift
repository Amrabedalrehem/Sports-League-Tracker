//
//  MockNetworkServiceTests.swift
//  SportFolioTests
//  Created by Shahuda on 08/05/2026.


import XCTest
@testable import SportFolio

final class MockNetworkServiceTests: XCTestCase {

    var mockService: MockNetworkService!

    override func setUpWithError() throws {
        mockService = MockNetworkService()
    }

    override func tearDownWithError() throws {
        mockService = nil
    }

   

    func testGetLeaguesSuccess() {

        let expectation = expectation(description: "Leagues Success")

        mockService.getLeagues(baseURL: "") { result in

            switch result {

            case .success(let response):

                XCTAssertEqual(response.success, 1)
                XCTAssertEqual(response.result!.count, 1)
                XCTAssertEqual(response.result?.first?.leagueName,
                               "Premier League")

            case .failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

   

    func testGetLeaguesFailure() {

        mockService.shouldReturnError = true

        let expectation = expectation(description: "Leagues Failure")

        mockService.getLeagues(baseURL: "") { result in

            switch result {

            case .success:
                XCTFail()

            case .failure:
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

   

    func testGetEventsSuccess() {

        let expectation = expectation(description: "Events Success")

        mockService.getEvents(
            baseURL: "",
            leagueId: 1,
            from: "",
            to: ""
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertEqual(response.result!.count, 1)
                XCTAssertEqual(response.result?.first?.eventHomeTeam,"Liverpool")

            case .failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    

    func testGetEventsFailure() {

        mockService.shouldReturnError = true

        let expectation = expectation(description: "Events Failure")

        mockService.getEvents(
            baseURL: "",
            leagueId: 1,
            from: "",
            to: ""
        ) { result in

            switch result {

            case .success:
                XCTFail()

            case .failure:
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    

    func testGetTeamsSuccess() {

        let expectation = expectation(description: "Teams Success")

        mockService.getTeams(
            baseURL: "",
            leagueId: 1
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertEqual(response.result!.count, 1)
                XCTAssertEqual(response.result?.first?.teamName,"Liverpool")

            case .failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

  

    func testGetTeamsFailure() {

        mockService.shouldReturnError = true

        let expectation = expectation(description: "Teams Failure")

        mockService.getTeams(
            baseURL: "",
            leagueId: 1
        ) { result in

            switch result {

            case .success:
                XCTFail()

            case .failure:
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

  

    func testGetTeamDetailsSuccess() {

        let expectation = expectation(description: "Team Details Success")

        mockService.getTeamDetails(
            baseURL: "",
            teamId: 1
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertEqual(response.result!.count, 1)
                XCTAssertEqual(response.result?.first?.players?.count,
                               1)

            case .failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

   

    func testGetTeamDetailsFailure() {

        mockService.shouldReturnError = true

        let expectation = expectation(description: "Team Details Failure")

        mockService.getTeamDetails(
            baseURL: "",
            teamId: 1
        ) { result in

            switch result {

            case .success:
                XCTFail()

            case .failure:
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

    

    func testGetPlayersSuccess() {

        let expectation = expectation(description: "Players Success")

        mockService.getPlayers(
            baseURL: "",
            leagueId: 1
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertEqual(response.result!.count, 1)
                XCTAssertEqual(response.result?.first?.playerName,"Mohamed Salah")
            case .failure:
                XCTFail()
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }

   

    func testGetPlayersFailure() {

        mockService.shouldReturnError = true

        let expectation = expectation(description: "Players Failure")

        mockService.getPlayers(
            baseURL: "",
            leagueId: 1
        ) { result in

            switch result {

            case .success:
                XCTFail()

            case .failure:
                XCTAssertTrue(true)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 2)
    }
}
