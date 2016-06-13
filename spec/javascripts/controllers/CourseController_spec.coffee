describe 'CourseController', ->
  scope         = null
  ctrl          = null
  routeParams   = null
  httpBackend   = null
  flash         = null
  location      = null
  courseId      = 42

  fakeCourse =
    id: courseId
    name: 'Calculus 1'
    code: 'MATH 1004'

  setupController =(courseExists=true, courseId=42)->
    inject(($location, $routeParams, $rootScope, $httpBackend, $controller, _flash_)->
      scope       = $rootScope.$new()
      location    = $location
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.courseId = courseId if courseId
      flash       = _flash_

      if courseId     # use {} for clarity
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

  describe 'create', ->
    newCourse =
      id: 42
      name: 'Toast'
      code: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController(false,false)
      request = new RegExp("\/courses")
      httpBackend.expectPOST(request).respond(201,newCourse)

    it 'posts to the backend', ->
      scope.course.name = newCourse.name
      scope.course.code = newCourse.code
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/courses/#{newCourse.id}")

  describe 'update', ->
    updatedCourse =
      name: 'Toast'
      code: 'put in toaster, push lever, add butter'

    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/courses")
      httpBackend.expectPUT(request).respond(204)

    it 'posts to the backend', ->
      scope.course.name = updatedCourse.name
      scope.course.code = updatedCourse.code
      scope.save()
      httpBackend.flush()
      expect(location.path()).toBe("/courses/#{scope.course.id}")

  describe 'delete' ,->
    beforeEach ->
      setupController()
      httpBackend.flush()
      request = new RegExp("\/courses/#{scope.course.id}")
      httpBackend.expectDELETE(request).respond(204)

    it 'posts to the backend', ->
      scope.delete()
      httpBackend.flush()
      expect(location.path()).toBe("/")
