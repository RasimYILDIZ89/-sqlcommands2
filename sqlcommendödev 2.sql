26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını 
(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.

select product_name,units_in_stock,suppliers.company_name,suppliers.phone
from products
inner join suppliers on products.supplier_id=suppliers.supplier_id
where units_in_stock=0 


27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı

select order_date,ship_address,employees.first_name,employees.last_name
from orders
inner join employees on orders.employee_id=employees.employee_id
WHERE EXTRACT(YEAR FROM order_date) = 1998
AND EXTRACT(MONTH FROM order_date) = 03

28. 1997 yılı şubat ayında kaç siparişim var?

select count(*) as siparis_sayısı
from orders
WHERE EXTRACT(YEAR FROM order_date) = 1997
AND EXTRACT(MONTH FROM order_date) = 02

29. London şehrinden 1998 yılında kaç siparişim var?

select count(*) ship_city 
from orders
WHERE EXTRACT(YEAR FROM order_date) = 1998 and ship_city='London'

30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası

select order_date,customers.contact_name,customers.phone
from orders
inner join customers on orders.customer_id=customers.customer_id
WHERE EXTRACT(YEAR FROM order_date) = 1997

31. Taşıma ücreti 40 üzeri olan siparişlerim

select ship_name,freight
from orders
where freight>40

32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı

select customers.contact_name,customers.company_name,ship_name,ship_city,freight
from orders
inner join customers on orders.customer_id=customers.customer_id
where freight>40

33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),

select order_date,ship_city, UPPER(concat(employees.first_name,' ',employees.last_name)) as full_name
from orders
inner join employees on orders.employee_id=employees.employee_id
where extract(year from order_date)=1997

34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )

select DISTINCT contact_name,RIGHT(REGEXP_REPLACE(customers.phone,'[^\d]','','g'),7) AS new_phone
from customers
inner join orders on customers.customer_id=orders.customer_id
where extract(year from order_date)=1997

SELECT DISTINCT contact_name,regexp_replace(c.phone, '\D', '', 'g') AS formatted_phone FROM orders AS o
INNER JOIN customers AS c ON c.customer_id = o.customer_id
WHERE to_char(order_date,'YYYY') = '1997';

35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad

select order_date,c.contact_name,e.first_name,e.last_name
from orders
inner join customers c on orders.customer_id=c.customer_id
inner join employees e on orders.employee_id=e.employee_id

36. Geciken siparişlerim?

select*from orders where shipped_date>required_date

37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT
c.company_name,
o.order_id,
o.required_date,
o.shipped_date,
EXTRACT(DAY FROM AGE(o.shipped_date, o.required_date)) AS delay_days
FROM
orders o
INNER JOIN
customers c ON c.customer_id = o.customer_id
WHERE
o.shipped_date > o.required_date;

38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT p.product_name, c.category_name, od.quantity
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = c.category_id
where od.order_id =10248

39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

select p.product_name,s.company_name
from products p
inner join suppliers s on p.supplier_id=s.supplier_id
inner join order_details od on p.product_id=od.product_id
where od.order_id =10248

40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT p.product_name, od.quantity
FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
AND EXTRACT(YEAR FROM o.order_date) = 1997;

41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.employee_id = (
    SELECT employee_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
    GROUP BY employee_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
INNER JOIN (
    SELECT employee_id, COUNT(*) AS total_sales
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
    GROUP BY employee_id
    ORDER BY total_sales DESC
    LIMIT 1
) AS top_seller ON e.employee_id = top_seller.employee_id;

43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

select p.product_name,p.unit_price,c.category_name,c.category_id
from products p
inner join categories c on p.category_id=c.category_id
order by unit_price desc
limit 1

44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

select o.order_id,o.order_date,e.first_name,e.last_name
from orders o
inner join employees e on e.employee_id=o.employee_id
order by order_date

45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

select o.order_id,od.unit_price
from orders o
inner join order_details od on o.order_id=od.order_id
order by order_id desc limit 5


46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

select p.product_name,c.category_name,sum(od.quantity) total_quantity
from products p
inner join categories c on p.category_id=c.category_id
inner join order_details od on od.product_id=p.product_id
inner join orders o on o.order_id=od.order_id
where extract (month from o.order_date)=1
GROUP BY p.product_name, c.category_name

47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

select*from order_details
where quantity>(select avg(quantity) from order_details) order by order_id

48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

select p.product_name,c.category_name,s.company_name,sum(od.quantity) as total_quantity
from order_details od
inner join products p on p.product_id=od.product_id
inner join categories c on p.category_id=c.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
group by p.product_name,s.company_name,c.category_name
order by sum(od.quantity) desc
limit 1

49. Kaç ülkeden müşterim var

select count(distinct country)
from customers

50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

select e.employee_id,sum(od.quantity) as total_quantity
from orders o
inner join employees e on o.employee_id=e.employee_id
inner join order_details od on o.order_id=od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = (SELECT EXTRACT(YEAR FROM MAX(order_date)) FROM orders)
AND e.employee_id = 3
GROUP BY e.employee_id;

51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi

SELECT p.product_name, c.category_name, od.quantity
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
INNER JOIN categories c ON p.category_id = c.category_id
where od.order_id =10248

52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı

select p.product_name,s.company_name
from products p
inner join suppliers s on p.supplier_id=s.supplier_id
inner join order_details od on p.product_id=od.product_id
where od.order_id =10248

53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti

SELECT p.product_name, od.quantity
FROM orders o
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN employees e ON o.employee_id = e.employee_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
AND EXTRACT(YEAR FROM o.order_date) = 1997;

54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
WHERE e.employee_id = (
    SELECT employee_id
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
    GROUP BY employee_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****

SELECT e.employee_id, e.first_name, e.last_name
FROM employees e
INNER JOIN (
    SELECT employee_id, COUNT(*) AS total_sales
    FROM orders
    WHERE EXTRACT(YEAR FROM order_date) = 1997
    GROUP BY employee_id
    ORDER BY total_sales DESC
    LIMIT 1
) AS top_seller ON e.employee_id = top_seller.employee_id;

56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?

select p.product_name,p.unit_price,c.category_name,c.category_id
from products p
inner join categories c on p.category_id=c.category_id
order by unit_price desc
limit 1

57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre

select o.order_id,o.order_date,e.first_name,e.last_name
from orders o
inner join employees e on e.employee_id=o.employee_id
order by order_date

58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?

select o.order_id,od.unit_price
from orders o
inner join order_details od on o.order_id=od.order_id
order by order_id desc limit 5

59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?

select p.product_name,c.category_name,sum(od.quantity) total_quantity
from products p
inner join categories c on p.category_id=c.category_id
inner join order_details od on od.product_id=p.product_id
inner join orders o on o.order_id=od.order_id
where extract (month from o.order_date)=1
GROUP BY p.product_name, c.category_name

60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?

select*from order_details
where quantity>(select avg(quantity) from order_details) order by order_id

61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı

select p.product_name,c.category_name,s.company_name,sum(od.quantity) as total_quantity
from order_details od
inner join products p on p.product_id=od.product_id
inner join categories c on p.category_id=c.category_id
inner join suppliers s on s.supplier_id=p.supplier_id
group by p.product_name,s.company_name,c.category_name
order by sum(od.quantity) desc
limit 1

62. Kaç ülkeden müşterim var

select count (distinct country)
from customers

63. Hangi ülkeden kaç müşterimiz var

select country,count(country) AS customer_count
from customers
group by country

SELECT country, COUNT(*) AS customer_count
FROM customers
GROUP BY country;

64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?

select e.employee_id,sum(od.quantity) as total_quantity
from orders o
inner join employees e on o.employee_id=e.employee_id
inner join order_details od on o.order_id=od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = (SELECT EXTRACT(YEAR FROM MAX(order_date)) FROM orders)
AND e.employee_id = 3
GROUP BY e.employee_id;

65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?

SELECT od.product_id, SUM(od.unit_price * od.quantity) AS toplam_ciro
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = (SELECT EXTRACT(MONTH FROM MAX(order_date)) FROM orders)
AND od.product_id = 10
GROUP BY od.product_id;

66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?

SELECT e.employee_id, e.first_name, e.last_name, COUNT(o.order_id) AS toplam_siparis
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name;

67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

SELECT distinct c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri

select company_name,contact_name,address,city,country
from customers
where country='Brazil'

69. Brezilya’da olmayan müşteriler

select distinct company_name,country
from customers
where country!='Brazil'

70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

select distinct company_name,country
from customers
where country in ('spain','France','Germany')

71. Faks numarasını bilmediğim müşteriler

select company_name,fax
from customers
where fax is null

72. Londra’da ya da Paris’de bulunan müşterilerim

select distinct company_name,city
from customers
where city in ('London','Paris')

73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler

select company_name,contact_title,city
from customers
where contact_title='Owner' and city='México D.F.'

74. C ile başlayan ürünlerimin isimleri ve fiyatları

select product_name,unit_price
from products
where lower(product_name) like 'c%'

75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri

select first_name,first_name,birth_date
from employees
where lower(first_name) like 'a%'

76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları

select company_name,contact_name
from customers
where upper(company_name) like '%RESTAURANT%'

77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları

select product_name,unit_price
from products
where unit_price between 50 and 100 

78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) 
ve SiparişTarihi (OrderDate) bilgileri

select order_id,order_date
from orders
where order_date between '1996-07-01' and '1996-12-31'

79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler

select distinct company_name,country
from customers
where country in ('Spain','France','Germany')

80. Faks numarasını bilmediğim müşteriler

select company_name,fax
from customers
where fax is null

81. Müşterilerimi ülkeye göre sıralıyorum:

select company_name,country
from customers
order by country

82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz

select product_name,unit_price
from products
order by unit_price desc

83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe 
doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz

select product_name,unit_price,units_in_stock
from products
order by unit_price desc,units_in_stock ASC;

84. 1 Numaralı kategoride kaç ürün vardır..?

select count(product_name)
from products
where category_id=1

85. Kaç farklı ülkeye ihracat yapıyorum..?

SELECT COUNT(DISTINCT ship_country)
FROM orders;

86. a.Bu ülkeler hangileri..?

SELECT DISTINCT ship_country
FROM orders;

87. En Pahalı 5 ürün

select product_name,unit_price
from products
order by unit_price desc limit 5

88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?

select count(*)
from orders
where customer_id='ALFKI'

89. Ürünlerimin toplam maliyeti

select sum(units_in_stock*unit_price) as total_cost
from products

90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?

SELECT SUM(od.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id;

SELECT SUM(od.quantity * od.unit_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id

91. Ortalama Ürün Fiyatım

select avg(unit_price)
from products

92. En Pahalı Ürünün Adı

select product_name,unit_price
from products
order by unit_price desc limit 1

93. En az kazandıran sipariş

SELECT  o.order_id, SUM(od.quantity * p.unit_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY o.order_id
ORDER BY total_revenue asc
LIMIT 1;

94. Müşterilerimin içinde en uzun isimli müşteri

select contact_name,length(contact_name) as en_uzun_isim
from customers
order by en_uzun_isim desc limit 1

95. Çalışanlarımın Ad, Soyad ve Yaşları

select first_name,last_name,birth_date
from employees

96. Hangi üründen toplam kaç adet alınmış..?

select product_name,sum(od.quantity)
from products p
inner join order_details od on p.product_id=od.product_id
GROUP BY p.product_name;

97. Hangi siparişte toplam ne kadar kazanmışım..?

select order_id,sum(quantity*unit_price)
from order_details
group by order_id

98. Hangi kategoride toplam kaç adet ürün bulunuyor..?

SELECT c.category_name, SUM(od.quantity) AS toplam_miktar
FROM categories c
INNER JOIN products p ON c.category_id = p.category_id
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY c.category_name
ORDER BY SUM(od.quantity) DESC;

99. 1000 Adetten fazla satılan ürünler?

SELECT p.product_name, SUM(od.quantity) AS toplam_satilan_miktar
FROM products p
INNER JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.product_name
HAVING SUM(od.quantity) > 1000;

100. Hangi Müşterilerim hiç sipariş vermemiş..?

select c.customer_id,c.company_name
from customers c
left join orders o on o.customer_id=c.customer_id
where o.order_id is null