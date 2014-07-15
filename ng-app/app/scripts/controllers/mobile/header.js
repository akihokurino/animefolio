'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:HeaderCtrl
 * @description
 * # HeaderCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("HeaderCtrl", function ($scope, $location) {
	$scope.initialize = function () {
		title();
	}

	$scope.$on('$routeChangeSuccess', function () {
		title();
	});

	function title () {
		var letter = $location.search().letter;
		var type = $location.search().type;
		if(letter){
			$scope.title = letter;
		}
		else if(type){
			if(type == "popular"){
				$scope.title = "人気";
			}
			else if(type == "recent"){
				$scope.title = "最近"
			}
		}
		else if(!letter && !type){
			$scope.title = "すべて"
		}

		if($location.path().split("/")[1] == "contents" || $location.path().split("/")[1] == "content"){
			$scope.title = "AnimeFolio"
		}
	}

	$scope.search = function (keyword) {
		var tmp_keyword = keyword;
		keyword = null;
		$(".keyword").val("");
		location.href = "#/?keyword=" + tmp_keyword
	}

	$scope.enter = function (keyword) {
		if(event.keyCode === 13 && keyword){
	    var tmp_keyword = keyword;
			keyword = null;
			$(".keyword").val("");
			location.href = "#/?keyword=" + tmp_keyword
	  }
	}

	$scope.showMenu = function () {
		if($(".menu").css("display") == "block"){
			$(".menu").css("display", "none");
			$("body").css("overflow", "auto");
			$(".layer").css("display", "none");
		}
		else{
			$(".menu").css("display", "block");
			$("body").css("overflow", "hidden");
			$(".layer").css("display", "block");
		}
	}
});

