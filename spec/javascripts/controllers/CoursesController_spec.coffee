describe "CoursesController", ->
  scope        = null
  ctrl         = null
  location     = null
  routeParams  = null
  resource     = null
  httpBackend  = null

  setupController =(keywords,results)->
    inject(($location, $routeParams, $rootScope, $resource, $httpBackend, $controller)->
      scope       = $rootScope.$new()
      location    = $location
      resource    = $resource
      httpBackend = $httpBackend
      routeParams = $routeParams
      routeParams.keywords = keywords

      if results
        request = new RegExp("\/courses.*keywords=#{keywords}")
        httpBackend.expectGET(request).respond(results)

      ctrl        = $controller('CoursesController',
                                $scope: scope
                                $location: location)
    )

  beforeEach(module("gradepal"))

  afterEach ->
    httpBackend.verifyNoOutstandingExpectation()
    httpBackend.verifyNoOutstandingRequest()

  describe 'controller initialization', ->
    describe 'when no keywords present', ->
      beforeEach(setupController())

      it 'defaults to no courses', ->
        expect(scope.courses).toEqualData([])

    describe 'with keywords', ->
      keywords = 'foo'
      courses = [
        {
          id: 2
          name: 'MATH 1004'
        },
        {
          id: 4
          name: 'MATH 1104'
        }
      ]
      beforeEach ->
        setupController(keywords,courses)
        httpBackend.flush()

      it 'calls the back-end', ->
        expect(scope.courses).toEqualData(courses)

  describe 'search()', ->
    beforeEach ->
      setupController()

    it 'redirects to itself with a keyword param', ->
      keywords = 'foo'
      scope.search(keywords)
      expect(location.path()).toBe("/")
      expect(location.search()).toEqualData({keywords: keywords})
