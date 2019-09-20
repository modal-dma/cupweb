<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="js/constants.js"></script>

<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Prestazioni</title>

<!-- CSS Files -->
<link type="text/css" href="css/base.css" rel="stylesheet" />
<link type="text/css" href="css/Treemap.css" rel="stylesheet" />

<!--[if IE]><script language="javascript" type="text/javascript" src="../../Extras/excanvas.js"></script><![endif]-->

<!-- JIT Library File -->
<script language="javascript" type="text/javascript" src="js/jit.js"></script>

<!-- Example File -->
<script language="javascript" type="text/javascript" src="js/branchePrestazioni.js"></script>

  </head>

  <body>  
              
    <script>

     function refresh()
     {
   	  	$("#ajaxloader").show();
   	  
     	var min = 5000, max = 0;
     	
     	var years = $(".year");
     	
     	for(var i = 0; i < years.length; i++)
     	{
     		var year = years[i];
     	
     		if(year.checked)
     		{
     			var v = parseInt(year.id);
     			if(v < min)
     				min = v;
     			
     			if(v > max)
     				max = v;			
     		}
     	}
     	//var branca = $('#branche').find(":selected").text();
     	//var prestazione = $('#prestazioni').find(":selected").text();
     	
     	//http://localhost:8090/modal/api/1.0.0/heatmapPrestazioni?prestazione=AMNIOCENTESI&limit=100
     			
     	var url = serverUrl + "/modal/api/1.0.0/branchePrestazioni?"

     	if(min < 5000) // trovato almeno uno
     		url += "startdate=01/01/" + min + "&enddate=31/12/" + max + "&";
     	      	
     	//url += "prestazione=" + prestazione;
     	
     	$.ajax({
   	    type: "GET",
   		url: url,
   		async: true,
   		error: function(e) {
   			//error({'error': e});
   			$("#ajaxloader").hide();
   		    alert("Impossibile comunicare con il servizio " + e);
   		},
   		success: function( model ) {
   			$("#ajaxloader").hide();
   			
   			var json = {
   					"children": [],
   					"data": {"playcount": 100}, 
   				   	"id": "root", 
   				   	"level": 0,
   				   	"name": "Prestazione in Branche"
   			};
				
   			var count = 1;
   			var totalArea = 0;
   			for (var key in model) 
   			{
   				//if(count > 10)
   				//	break;
   				
   			    if (model.hasOwnProperty(key)) 
   			    {
   			    	var color = getColor(count * 10);
   			    	count++;
   			    	
   			    	var root = {
   							"id": key, 
   							"name": key,
   							"children": [],
   							"data": {}
   					};
   			    	
   			    	var area = 0;
   			    	var children = model[key];
     					
     					for(var i = 0; i < children.length; i++)
     					{
     						var child = children[i];
     						var val = parseInt(child.value);// / 1000;
     						
     						if(val > 2)
     						{
	     						var data = {
	       							"id": key + i, 
	       							"name": child.title,
	       							"children": [],
	       							"data": {
	       								"$color": color,
	       								"playcount": child.value, 
	       					      		"$area": "" + val,
	       					      		"level": 2
	       					      		//"$dim": child.value
	       							}    
	     						};
	     						
	     						area += val;
	         					
	         					root.children.push(data);
     						}
       					}
     					
     					var actualChildren = [];
     					
     					for(var i = 0; i < root.children.length; i++)
         				{
     						var child = root.children[i];
     						child.data.playcount = (child.data.playcount / area) * 100;
     						
     						if(child.data.playcount >= 1)
     							actualChildren.push(child);
         				}
     						     		
     					root.children = actualChildren;
     					
     					root.data = {
     						"$color": pSBC(-0.5, color),
     						"playcount": area,
				      		"$area": "" + area,
				      		"level": 1
				      		//"$dim": "" + area
						};   	
     					
     					totalArea += area;
     					//if(area > 100000)
     						json.children.push(root);
   			    }   			       			 	   			    
   			}
   			
   			for(var i = 0; i < json.children.length; i++)
			{
				var child = json.children[i];
				child.data.playcount = (child.data.playcount / totalArea) * 100;
			}
   			
   			$('#infovis').css("height", $(window).height() + "px");
   			$('#infovis').html("");
   			createTreemap(json);    			    			
   		}
   	});      	      	      				      
     }                 
     
     function getColor(i)
     {
    	var frequency = .3;
    	var amplitude = 127;
    	var center = 128;
    	var phase = 128;
    		
		var red   = Math.sin(frequency*i+2+phase) * amplitude + center;
	    var green = Math.sin(frequency*i+0+phase) * amplitude + center;
	    var blue  = Math.sin(frequency*i+4+phase) * amplitude + center;
		    
		return 'rgba(' + red + ', ' + green+ ', ' + blue + ', 0.2)';
   		
     }
      
  // Version 4.0
     const pSBC=(p,c0,c1,l)=>{
         let r,g,b,P,f,t,h,i=parseInt,m=Math.round,a=typeof(c1)=="string";
         if(typeof(p)!="number"||p<-1||p>1||typeof(c0)!="string"||(c0[0]!='r'&&c0[0]!='#')||(c1&&!a))return null;
         if(!this.pSBCr)this.pSBCr=(d)=>{
             let n=d.length,x={};
             if(n>9){
                 [r,g,b,a]=d=d.split(","),n=d.length;
                 if(n<3||n>4)return null;
                 x.r=i(r[3]=="a"?r.slice(5):r.slice(4)),x.g=i(g),x.b=i(b),x.a=a?parseFloat(a):-1
             }else{
                 if(n==8||n==6||n<4)return null;
                 if(n<6)d="#"+d[1]+d[1]+d[2]+d[2]+d[3]+d[3]+(n>4?d[4]+d[4]:"");
                 d=i(d.slice(1),16);
                 if(n==9||n==5)x.r=d>>24&255,x.g=d>>16&255,x.b=d>>8&255,x.a=m((d&255)/0.255)/1000;
                 else x.r=d>>16,x.g=d>>8&255,x.b=d&255,x.a=-1
             }return x};
         h=c0.length>9,h=a?c1.length>9?true:c1=="c"?!h:false:h,f=pSBCr(c0),P=p<0,t=c1&&c1!="c"?pSBCr(c1):P?{r:0,g:0,b:0,a:-1}:{r:255,g:255,b:255,a:-1},p=P?p*-1:p,P=1-p;
         if(!f||!t)return null;
         if(l)r=m(P*f.r+p*t.r),g=m(P*f.g+p*t.g),b=m(P*f.b+p*t.b);
         else r=m((P*f.r**2+p*t.r**2)**0.5),g=m((P*f.g**2+p*t.g**2)**0.5),b=m((P*f.b**2+p*t.b**2)**0.5);
         a=f.a,t=t.a,f=a>=0||t>=0,a=f?a<0?t:t<0?a:a*P+t*p:0;
         if(h)return"rgb"+(f?"a(":"(")+r+","+g+","+b+(f?","+m(a*1000)/1000:"")+")";
         else return"#"+(4294967296+r*16777216+g*65536+b*256+(f?m(a*255):0)).toString(16).slice(1,f?undefined:-2)
     }
     
    </script>
  	<div id="container">
			<div id="center-container">
    			<div id="infovis"></div>    
			</div>
		</div>
		
		<script>
		$('#infovis').css("height", ($(window).height() - $('#branche').height() - 20) + "px");
		
		$(document.body).append('<img id="ajaxloader" src="images/ajax-loader.gif" alt="Wait" style="vertical-align: middle; width: 90px; height:90px" />');
		$("#ajaxloader").css({position: 'absolute', top: (($(window).height() / 2) - ($("#ajaxloader").width() / 2)) + "px", left: ($(window).width() - $("#ajaxloader").width()) / 2 + "px", zIndex: 1000});
		$("#ajaxloader").hide();


		refresh();
		</script>
  </body>
</html>
