(function () {
  angular.module('gradepal.main.controllers').controller('CourseCardCtrl', CourseCardCtrl);

  CourseCardCtrl.$inject = ['$scope', '$resource', 'flash'];

  function CourseCardCtrl($scope, $resource, flash) {
    var Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'},
        'create': {method: 'POST'},
        'save': {method: 'PUT'}
      });
    var Component = $resource('components/:componentId', { format: 'json' },
      {
        'delete': {method: 'DELETE'},
        'create': {method: 'POST'},
        'save': {method: 'PUT'}
      });

    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      // ctrl.course = $scope.gpCourse ? $scope.gpCourse : {};
      // ctrl.course.id = $scope.gpCourseId;
      ctrl.editing = $scope.gpEditing;
      ctrl.selected = false;
      ctrl.getComponents();
    }

    ctrl.getComponents = function () {
      if($scope.gpCourse && $scope.gpCourse.id) {
        Component.query({course_id: $scope.gpCourse.id}, function (results) {
          $scope.gpCourse.components = results.sort(function (a,b) {
            return a.id - b.id;
          });
        });
      }
    }

    ctrl.showNewComponent = function () {
      ctrl.addingComponent = true; // view will show the appropriate box
    }

    ctrl.toggleSelect = function () {
      if (ctrl.isSelected = !ctrl.isSelected){
        ctrl.getComponents();
      }
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      console.log('Editing course with id: ' + $scope.gpCourse.id);
    }

    ctrl.delete = function () {
      console.log('Deleting course with id: ' + $scope.gpCourse.id);
      $scope.gpCourse.$delete();
      $scope.gpParentCtrl.updateList();
      // $scope.$destroy();
    }

    ctrl.save = function () {
      console.log('Saving course with code: ' + $scope.gpCourse.code + ', name: ' + $scope.gpCourse.name);
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!$scope.gpCourse.code) { // bad input
        flash.error = 'Please enter a code for the course';
        return;
      }
      if (!$scope.gpCourse.name) { // bad input
        flash.error = 'Please enter a name for the course';
        return;
      }
      ctrl.editing = false; // successful, so close dialog

      if($scope.gpCourse && $scope.gpCourse.id) { // This is an existing course if it already has an id; editing, not creating
        $scope.gpCourse.$save(
          (function() {
            console.log('Updated course with id ' + $scope.gpCourse.id);
          }),
          onError
        );
      }
      else { // This is a new course if it does not have an id
        Course.create($scope.gpCourse, (
          function (createdCourse) {
            // flash.success = "Course created successfully"
            $scope.gpCourse = createdCourse;
            console.log('Created course with id: ' + $scope.gpCourse.id);
            $scope.gpParentCtrl.updateList();
            $scope.gpParentCtrl.addingCourse = false;
          }),
            onError
        );
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if($scope.gpCourse && $scope.gpCourse.id) { // existing course
        console.log('Cancel changes to course');
        Course.get({courseId: $scope.gpCourse.id}, function (result) {
          console.log(result);
          $scope.gpCourse = result;
        });
      }
      ctrl.editing = false;
      $scope.gpParentCtrl.addingCourse = false;
    }

    ctrl.init();
  }

})();
