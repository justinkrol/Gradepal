(function () {
  angular.module('gradepal.main.controllers').controller('CourseCardCtrl', CourseCardCtrl);

  CourseCardCtrl.$inject = ['$scope', '$resource', 'flash'];

  function CourseCardCtrl($scope, $resource, flash) {
    var Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'}
        'create': {method: 'POST'}
        'save': {method: 'PUT'}
      });

    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      ctrl.id = $scope.gpCourseId;
      ctrl.editing = $scope.gpEditing;
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      ctrl.temp = {code: ctrl.code, name: ctrl.name};
      console.log('Editing course with id: ' + ctrl.id);
    }

    ctrl.save = function () {
      console.log('Saving course with code: ' + ctrl.code + ', name: ' + ctrl.name);
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!ctrl.name) {
        flash.error = 'Please enter a name for the course';
        return;
      }
      if(ctrl.id) { // This is an existing course if it already has an id; editing, not creating
        new Course {code: ctrl.code, name: ctrl.name}.$save (( function () {f
          console.log('Updated course with id ' + ctrl.id);
          // need to update list
        }),
          onError
        )
      }
      else { // This is a new course if it does not have an id
        Course.create(ctrl, (
          function (createdCourse) {
            flash.success = "Course created successfully"
            console.log('Created course with id: ' + ctrl.id);
            // need to update list
          }),
            onError
        )
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.id && ctrl.temp) { // existing course
        ctrl.code = ctrl.temp.code;
        ctrl.name = ctrl.temp.name;
      }
    }

    ctrl.init();
  }

})();
