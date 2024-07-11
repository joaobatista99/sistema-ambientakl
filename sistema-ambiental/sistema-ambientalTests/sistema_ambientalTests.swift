//
//  sistema_ambientalTests.swift
//  sistema-ambientalTests
//
//  Created by João Victor Batista on 10/07/24.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
@testable import sistema_ambiental

class ProjectListViewModelTests: XCTestCase {
    
    var viewModel: ProjectListViewModel!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    var mockProjectService: MockProjectService!
    var mockProjects: [Project] = [
        Project(title: "Project A", id: "1"),
        Project(title: "Project B", id: "2"),
        Project(title: "Project C", id: "3")
    ]
    
    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
        mockProjectService = MockProjectService()
        viewModel = ProjectListViewModel()
        viewModel.service = mockProjectService
        mockProjectService.projects = mockProjects
    }
    
    override func tearDown() {
        viewModel = nil
        mockProjectService = nil
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testGetAllProjectsSuccess() {
        
        let projectsObserver = scheduler.createObserver([Project].self)
        viewModel.projectsDriver.drive(projectsObserver).disposed(by: disposeBag)
        viewModel.getAllProjects()
        scheduler.start()
        
        let emptyProjects: [Project] = []
        let expectedProjects = [Recorded.next(0, emptyProjects), Recorded.next(0, mockProjects)]
        XCTAssertEqual(projectsObserver.events, expectedProjects)
    }
    
    func testSearchProjectsSuccess() {
    
        let projectsObserver = scheduler.createObserver([Project].self)
        viewModel.projectsDriver.drive(projectsObserver).disposed(by: disposeBag)
        viewModel.searchProjects(with: "Project A")
        scheduler.start()
        
        let emptyProjects: [Project] = []
        let searchedProjects = [Recorded.next(0, emptyProjects),
                                Recorded.next(0, [Project(title: "Project A", id: "1")])]
        XCTAssertEqual(projectsObserver.events, searchedProjects)
    }
    
}
