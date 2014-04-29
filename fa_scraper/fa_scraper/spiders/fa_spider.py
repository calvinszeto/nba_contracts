from scrapy.spider import Spider
from scrapy.selector import Selector

from fa_scraper.items import FreeAgent
import re

class FaSpider(Spider):
    name = "fa"
    allowed_domains = ["http://en.wikipedia.org"]
    start_urls = [
        "http://en.wikipedia.org/wiki/List_of_2006-07_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2007-08_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2008-09_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2009-10_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2010-11_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2011-12_NBA_season_transactions",
        "http://en.wikipedia.org/wiki/List_of_2012-13_NBA_season_transactions"
    ]

    title_re = re.compile(r'^List of 20(\d\d).*$')

    def parse(self, response):
        sel = Selector(response)
        title = sel.xpath('//h1/span[1]/text()').extract()[0]
        year = self.title_re.match(title).groups()[0]
        season = "{year1}-{year2}".format(year1=year
                ,year2=str(int(year)+1).zfill(2))
        if season == "06-07":
            names = (sel.xpath(
                '//h2/span[@id="Free_Agency"]/'
                '../../table[@style="text-align:center"][1]/tr/td[1]'
                '/a'))
        elif season == "07-08":
            names = (sel.xpath(
                '//h2/span[@id="Free_Agency"]/'
                '../../table[@style="text-align:left"][1]/tr/td'
                '/span/span/a'))
        elif season == "08-09":
            names = (sel.xpath(
                '//h3/span[@id="Free_agency"]/'
                '../../table[@style="text-align:center"][2]/tr/td[@align="left"]'
                '/a'))
        elif season == "09-10":
            names = (sel.xpath(
                '//h3/span[@id="Signed_from_free_agency"]/'
                '../../table[@style="text-align: center"][1]/tr/td[1]/a'))
        elif season == "10-11":
            names = (sel.xpath(
                '//h3/span[@id="Signed_from_free_agency"]/'
                '../../table[@style="text-align: center; width:80%"][1]/tr/td[1]/a'))
        elif season == "11-12" or season == "12-13":
            names = (sel.xpath(
                '//h3/span[@id="Free_agency"]/'
                '../../table[@style="text-align:center"][2]/tr/td/'
                'span/span/a'))
        for name in names:
            fa = FreeAgent()
            fa['Player'] = name.xpath('text()').extract()
            fa['Season'] = season
            team = name.xpath('../../td/a/text()')
            if team:
                team = team[1].extract()
            else:
                team = name.xpath('../../../../td/a/text()')
                if team:
                    team = team[0].extract()
            fa['Team'] =  team
            yield fa
