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

    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      ctrl.course = $scope.gpCourse
      // ctrl.course.id = $scope.gpCourseId;
      ctrl.editing = $scope.gpEditing;
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      ctrl.temp = {code: ctrl.course.code, name: ctrl.course.name};
      console.log('Editing course with id: ' + ctrl.course.id);
    }

    ctrl.delete = function () {
      console.log('Deleting course with id: ' + ctrl.course.id);
      ctrl.course.$delete();
      $scope.$destroy();
    }

    ctrl.save = function () {
      console.log('Saving course with code: ' + ctrl.course.code + ', name: ' + ctrl.course.name);
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!ctrl.course.name) { // bad input
        flash.error = 'Please enter a name for the course';
        return;
      }
      ctrl.editing = false; // successful, so close dialog
      $scope.gpParentCtrl.addingCourse = false;

      if(ctrl.course.id) { // This is an existing course if it already has an id; editing, not creating
        ctrl.course.$save(
          (function() { console.log('Updated course with id ' + ctrl.course.id); }),
          onError
        );
      }
      else { // This is a new course if it does not have an id
        Course.create(ctrl.course, (
          function (createdCourse) {
            flash.success = "Course created successfully"
            ctrl.course = createdCourse;
            console.log('Created course with id: ' + ctrl.course.id);
            $scope.gpParentCtrl.updateList();
          }),
            onError
        );
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.course.id && ctrl.temp) { // existing course
        console.log('a');
        ctrl.course.code = ctrl.temp.code;
        ctrl.course.name = ctrl.temp.name;
      }
      ctrl.editing = false;
      $scope.gpParentCtrl.addingCourse = false;
    }

    ctrl.init();
  }

})();
