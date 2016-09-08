#Copyright Vincent Gosselin 2016, soon to be an electrical engineer.

#Note : After inspecting http://shopicruit.myshopify.com, I discovered that the catalog has 12 pages.

require 'open-uri'#to open webpages like they were files.
require 'nokogiri'#best documentation for nokogiri is at https://blog.engineyard.com/2010/getting-started-with-nokogiri

#Step 1. Download each page of the catalog and put it into an array called  'catalog'.
catalog = []

1.upto(12) do |number|
	page = Nokogiri::HTML(open("http://shopicruit.myshopify.com/collections/all?page=#{number}"))
	catalog << page
end #Now catalog is full of pages with Nokogiri's magic into it.

#Note : I discovered that each robot's name and the price were included in the tags <a> under a class named "product"

    # <a href="/products/aerodynamic-concrete-clock" class="product">
    #   <img src="//cdn.shopify.com/s/files/1/1000/7970/products/Aerodynamic_20Concrete_20Clock_large.png?v=1443055734" alt="Aerodynamic Concrete Clock" class="product__img">
    #   <div class="product__cover"></div>
      

    #   <div class="product__details text-center">
    #     <div class="table-contain">
    #       <div class="table-contain__inner">
    #         <p class="h4 product__title">Aerodynamic Concrete Clock</p>
    #         <p class="product__price">
              
    #           From $4.32
              
    #         </p>
    #       </div>
    #     </div>
    #   </div>
    
    
    # </a>
 
#Step 2. Extract each robot's name and price information, put it into a robots array.
robots = []

catalog.each do |page|
	products_quantity = page.xpath('//a[@class = "product"]').count #how many products in one page.
	last_index = products_quantity-1 #last valid index of to consult page.xpath('//a[@class = "product"]')[INDEX_HERE]
	0.upto(last_index) do |index|
		product_info = page.xpath('//a[@class = "product"]')[index].text
		robots << "#{product_info.gsub(" ",'').gsub("\n",'')}"#clean string at the same time.
	end
end

#p robots.count# There are 133 robots in the catalog, now lets find all watches and clocks.

#Step 3. Scan through the robots array and extract the watches and clocks.

watches = []
clocks = []

robots.each do |robot|
	watches << robot if robot.match(/watch/i)
	clocks << robot if robot.match(/clock/i)
end

#p clocks.count# There are 8 clocks in the catalog.
#p watches.count# There are 5 watches in the catalog.

#Step 4. Sum of the prices for watches and clocks.

watches_price_total = 0
clocks_price_total = 0

watches.each do |watch|
	watches_price_total += watch.scan(/\d\.*/).join.to_f #scan for a valid regular expressions containing digits, a period ".".
end

clocks.each do |clock|
	clocks_price_total += clock.scan(/\d\.*/).join.to_f
end

watches_price_total = watches_price_total.round(2)# use of round here to get rid of numbers like 76.32000000000001
clocks_price_total = clocks_price_total.round(2)

#p watches_price_total
#p clocks_price_total

#Step 5. Calculate Grand total!

grand_total = clocks_price_total + watches_price_total
grand_total = "%.2f" % grand_total.to_f# String format to display 2 decimals.


puts "There are #{watches.count} watches and #{clocks.count} clocks in the catalog."
puts "To buy all the clocks and watches, it would cost #{grand_total}$"

# Output is : There are 5 watches and 8 clocks in the catalog.
#			  To buy all the clocks and watches, it would cost 269.10$


#Thank you so much for reading my code, 
#if you have any advice please let me know : vincentgosselin1@gmail.com














