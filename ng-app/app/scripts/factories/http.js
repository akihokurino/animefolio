angular.module("animefolio").factory("http", ["$http", "$rootScope", "env", function ($http, $rootScope, env){
	var HOST = env.getHost();

	function http (url, method, data, success_fn, error_fn) {
		$http({
			url: url,
			method: method,
			data: data,
			withCredentials: true,
			header: {
        'Content-Type': 'application/x-www-form-urlencoded'
      }
		})
		.success(success_fn)
		.error(error_fn);
	}

	return {
		getFilms: function (scope_api, page_num, scope_status, pagenation, letter) {
			var url;
			if(letter){
				url = HOST + "/films?page_num=" + page_num + "&letter=" + letter
			}
			else{
				url = HOST + "/films?page_num=" + page_num
			}
			http(url, "GET", {},
				function (data, status, headers, config) {
					angular.forEach(data.films, function (film) {
						scope_api.films.push(film);
					});
					scope_status.loading = false;

					if(data.films.length != 0){
						$(window).bind("scroll", pagenation);
					}
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		},
		searchFilms: function (scope_api, page_num, scope_status, pagenation, keyword) {
			http(HOST + "/films?page_num=" + page_num + "&keyword=" + keyword, "GET", {},
				function (data, status, headers, config) {
					angular.forEach(data.films, function (film) {
						scope_api.films.push(film);
					});
					scope_status.loading = false;

					if(data.films.length != 0){
						$(window).bind("scroll", pagenation);
					}
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		},
		getPopularOrRecentOrNewFilms: function (scope_api, page_num, scope_status, pagenation, type) {
			http(HOST + "/films?page_num=" + page_num + "&type=" + type, "GET", {},
				function (data, status, headers, config) {
					angular.forEach(data.films, function (film) {
						scope_api.films.push(film);
					});
					scope_status.loading = false;

					if(data.films.length != 0){
						$(window).bind("scroll", pagenation);
					}
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		},
		getFilm: function (scope_api, film_id) {
			http(HOST + "/films/" + film_id, "GET", {},
				function (data, status, headers, config) {
					scope_api.film = data.film;
					$rootScope.$broadcast("film", data.film);
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		},
		getContent: function (scope_api, content_id, film_id) {
			http(HOST + "/contents/" + content_id + "?film_id=" + film_id, "GET", {},
				function (data, status, headers, config) {
					scope_api.film = data.film;
					scope_api.content = data.content;
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		},
		getRecentList: function (scope_api) {
			http(HOST + "/anime_maps", "GET", {},
				function (data, status, headers, config) {
					angular.forEach(data.result, function (anime) {
						switch (anime.week) {
							case "日":
								scope_api.sunday_map.push(anime);
								break;
							case "月":
								scope_api.monday_map.push(anime);
								break;
							case "火":
								scope_api.tuesday_map.push(anime);
								break;
							case "水":
								scope_api.wednesday_map.push(anime);
								break;
							case "木":
								scope_api.thursday_map.push(anime);
								break;
							case "金":
								scope_api.friday_map.push(anime);
								break;
							case "土":
								scope_api.saturday_map.push(anime);
								break;
						}
					})

					console.log(scope_api)
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		}
	}
}])
