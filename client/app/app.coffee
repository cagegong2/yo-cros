'use strict'

angular.module('yoCrosApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ui.bootstrap',
  'ui.router'
])
  .constant 'configs',
    baseUrl: 'http://115.29.244.232'
  .config (($stateProvider, $urlRouterProvider, $locationProvider, $httpProvider) ->
    $urlRouterProvider
    .otherwise('/')

    $locationProvider.html5Mode true
    $httpProvider.interceptors.push 'urlInterceptor'
    $httpProvider.interceptors.push 'authInterceptor'
  )
  .factory('urlInterceptor', ($rootScope, $q, $cookieStore, $location,configs) ->
    # Add authorization token to headers
    request: (config) ->
      if config.url.startsWith('/api')
        config.url = configs.baseUrl + config.url
      config
  )
  .factory('authInterceptor', ($rootScope, $q, $cookieStore, $location) ->
    # Add authorization token to headers
    request: (config) ->
      config.headers = config.headers or {}
      config.headers.Authorization = 'Bearer ' + $cookieStore.get('token')  if $cookieStore.get('token')
      config

    # Intercept 401s and redirect you to login
    responseError: (response) ->
      if response.status is 401
        $location.path '/login'
        # remove any stale tokens
        $cookieStore.remove 'token'
        $q.reject response
      else
        $q.reject response
  )
  .run (($rootScope, $location, Auth) ->
    # Redirect to login if route requires auth and you're not logged in
    $rootScope.$on '$stateChangeStart', (event, next) ->
      $location.path '/login'  if next.authenticate and not Auth.isLoggedIn()
  )
