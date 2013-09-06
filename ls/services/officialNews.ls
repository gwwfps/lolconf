angular.module \lolconf .factory \LCOfficialNews, ($q, LC-logger) ->   
  require! 'request'
  {resolve} = require 'url'
  {map} = require 'lodash'

  url = 'http://beta.na.leagueoflegends.com/en/news/'

  {
    list: ->
      deferred = $q.defer!
      request url, !(error, response, body) ->
        LC-logger.info "Received response for official news, status %s", response.status-code
        if !error && response.status-code == 200
          sanitized = body.replace /src=/g, 'data-src='
          news-page-dom = $ sanitized
          news-section = news-page-dom.find '.view-news-recent'
          articles = map (news-section.find '.gs-container'), (article) ->            
            article-container = $ article
            img = article-container.find '.field-name-field-article-media img'
            title = article-container.find 'h4 a'
            summary = article-container.find 'teaser-content'
            {
              title: title.text!
              summary: summary.text!
              url: resolve url, (title.attr 'href')
              img-url: resolve url, (img.attr 'data-src')
            }
          deferred.resolve articles
        else
          deferred.reject error
      deferred.promise
  }

