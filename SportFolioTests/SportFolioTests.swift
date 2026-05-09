//
//  SportFolioTests.swift
//  SportFolioTests
//
//  Created by JETSMobileLabMini2 on 30/04/2026.
//

import XCTest
@testable import SportFolio

final class NetworkServiceTests: XCTestCase {

    var networkService: NetworkService!
    var sportType : SportType!
    override func setUpWithError() throws {
        networkService = NetworkServiceImpl.shared
        sportType = .football
    }

    override func tearDownWithError() throws {
        networkService = nil
        sportType = nil
    }

    

    func testGetLeagues_ShouldReturnLeagues() {

        let expectation = expectation(description: "Leagues API Call")
      
        networkService.getLeagues(
            baseURL: sportType.baseURL
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertNotNil(response.result)
                XCTAssertFalse(response.result!.isEmpty)

            case .failure(let error):

                XCTFail("API Failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    

    func testGetEvents_ShouldReturnEvents() {

        let expectation = expectation(description: "Events API Call")

        networkService.getEvents(
            baseURL: sportType.baseURL,
            leagueId: 152,
            from: "2025-01-01",
            to: "2025-12-31"
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertNotNil(response.result)

            case .failure(let error):

                XCTFail("API Failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout:20 )
    }

   

    func testGetTeams_ShouldReturnTeams() {

        let expectation = expectation(description: "Teams API Call")

        networkService.getTeams(
            baseURL: sportType.baseURL,
            leagueId: 152
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertNotNil(response.result)
                XCTAssertFalse(response.result!.isEmpty)

            case .failure(let error):

                XCTFail("API Failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

   

    func testGetTeamDetails_ShouldReturnTeam() {

        let expectation = expectation(description: "Team Details API Call")

        networkService.getTeamDetails(
            baseURL: sportType.baseURL,
            teamId: 96
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertNotNil(response.result)
                XCTAssertFalse(response.result!.isEmpty)

            case .failure(let error):

                XCTFail("API Failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

   

    func testGetPlayers_ShouldReturnPlayers() {

        let expectation = expectation(description: "Players API Call")

        networkService.getPlayers(
            baseURL: sportType.baseURL,
            leagueId: 152
        ) { result in

            switch result {

            case .success(let response):

                XCTAssertNotNil(response.result)
                XCTAssertFalse(response.result!.isEmpty)

            case .failure(let error):

                XCTFail("API Failed with error: \(error.localizedDescription)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10)
    }
}
