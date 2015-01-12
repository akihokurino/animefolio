'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:ContentCtrl
 * @description
 * # ContentCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("ContentCtrl", function ($scope, $location, $sce, http) {
	$scope.api = {
		film:         null,
		content:      [],
    iframe_links: [],
    text_links:   []
	};

 	$scope.initialize = function () {
 		var url_array  = $location.path().split("/");
 		var content_id = url_array.pop();
 		var film_id    = url_array.pop();
 		http.getContent($scope.api, content_id, film_id);
 	}

 	$scope.appendUrl = function (url) {
    return $sce.trustAsResourceUrl(url);
  }
});

