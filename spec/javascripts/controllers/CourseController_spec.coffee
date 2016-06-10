describe 'CourseController', ->
  scope         = null
  ctrl          = null
  routeParams   = null
  httpBackend   = null
  flash         = null
  courseId      = 42

  fakeCourse =
    id: courseId
    name: 'Calculus 1'
    code: 'MATH 1004'

  setupController =(courseExists=true)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.courseId = courseId
      flash       = _flash_

      request = new RegExp("\/courses/#{courseId}")
      results =
      if courseExists
        [200, fakeCourse]
      else
        [404]

      httpBackend.expectGET(request).respond(results[0], results[1])

      ctrl = $controller('CourseController', $scope: scope)
    )

  beforeEach(module('gradepal'))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'course is found', ->
      beforeEach(setupController())
      it 'loads the given course', ->
        httpBackend.flush()
        expect(scope.course).toEqualData(fakeCourse)
    describe 'course is not found', ->
      beforeEach(setupController(false))
      it 'loads the given course', ->
        httpBackend.flush()
        expect(scope.course).toBe(null)
        expect(flash.error).toBe("There is no course with ID #{courseId}")
