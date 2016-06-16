controllers = angular.module('controllers')
controllers.controller("CoursesController", [ '$scope', '$routeParams', '$location', '$resource', 'flash'
  ($scope, $routeParams, $location, $resource, flash)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)
    Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'}
        'create': {method: 'POST'}
      }
    )

    init = ()->
      $scope.showNewCourseInput = false
      $scope.newCourse = {}
      updateList()

    updateList = ()->
      if $routeParams.keywords
        Course.query(keywords: $routeParams.keywords, (results)-> $scope.courses = results)
      else
        Course.query((results)-> $scope.courses = results)

    $scope.view = (courseId)-> $location.path("/courses/#{courseId}")
    $scope.newCourse = -> $location.path("courses/new")
    $scope.edit = (courseId)-> $location.path("/courses/#{courseId}/edit")
    $scope.delete = (courseId)->
      $scope.course = Course.get({courseId: courseId},
        ()-> $scope.course.$delete().then(
          ( value )-> updateList(),
          ( error )-> alert('error')
        )
      )
    $scope.showNewCourse = (bShow)->
      $scope.showNewCourseInput = bShow

    $scope.submitCourse = ()->
      console.log('Submitting course')
      onError = (_httpResponse)->
        flash.error = "Something went wrong"
      if($scope.newCourse.name)
        Course.create($scope.newCourse,
          ( (createdCourse)->
            flash.sucess = "Course created"
            $scope.newCourse = {}
            console.log('Created course with id' + createdCourse.id)
            updateList()),
          onError)
        $scope.showNewCourseInput = false
      else
        flash.error = "Please enter a name for the course"

      # need to do this after or the create can't get the info from the scope since the form is hidden

    # Init
    init()

])
