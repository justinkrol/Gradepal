controllers = angular.module('controllers')
controllers.controller("CoursesController", [ '$scope', '$routeParams', '$location', '$resource', '$filter', 'flash'
  ($scope, $routeParams, $location, $resource, $filter, flash)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)
    Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'}
        'create': {method: 'POST'}
        'save': {method: 'PUT'}
      }
    )

    # variables
    newCourse = {}

    init = ()->
      $scope.showNewCourseInput = false
      $scope.editCourseId = null
      $scope.courseInput = null
      newCourse = new Course {} # store this so that  user can close the input, reopen and still see the same data
      updateList()

    updateList = ()->
      if $routeParams.keywords
        Course.query(keywords: $routeParams.keywords, (results)-> $scope.courses = results)
      else
        Course.query((results)-> $scope.courses = results)

    $scope.view = (courseId)-> $location.path("/courses/#{courseId}")
    $scope.newCourse = -> $location.path("courses/new")
    $scope.edit = (courseId)->
      $scope.showNewCourse(false)
      $scope.editCourseId = courseId
      courseToEdit = $filter('filter')($scope.courses, {id: courseId}, true)[0] #only one result in list
      editCourse = $.extend(true, {}, courseToEdit) # clone, need this in case they 'cancel'
      console.log(editCourse.id)
      $scope.courseInput = editCourse # assign the reference to the scope object
    $scope.delete = (courseId)->
      $scope.course = Course.get({courseId: courseId},
        ()-> $scope.course.$delete().then(
          ( value )-> updateList(),
          ( error )-> alert('error')
        )
      )
    $scope.showNewCourse = (bShow)->
      $scope.showNewCourseInput = bShow
      $scope.courseInput = newCourse
      $scope.editCourseId = {} # this should be hidden any time the add course button or cancel is clicked

    $scope.save = ()->
      console.log('Submitting course')
      onError = (_httpResponse)->
        flash.error = "Something went wrong"
      if($scope.courseInput.name)
        if($scope.courseInput.id) # Editing an existing course if it already has an id
          $scope.courseInput.$save( (
            ()->
              console.log('Updated course with id' + $scope.courseInput.id)
              $scope.courseInput = {}
              $scope.editCourseId = null
              updateList()),
            onError)
        else  # Saving a new course if it doesn't
          Course.create($scope.courseInput, (
            (createdCourse)->
              flash.sucess = "Course created"
              $scope.courseInput = {}
              console.log('Created course with id' + createdCourse.id)
              updateList()),
            onError)
        $scope.showNewCourseInput = false # do after save/create or the  can't get info from the scope
      else
        flash.error = "Please enter a name for the course"

    # Init
    init()
])
