'use strict'

angular.module('yoCrosApp')
  .config ($stateProvider) ->
    $stateProvider
    .state('admin',
      url: '/admin',
      templateUrl: 'app/admin/admin.html'
      controller: 'AdminCtrl'
    )