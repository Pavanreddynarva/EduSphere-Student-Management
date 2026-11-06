<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List,java.math.BigDecimal,java.math.RoundingMode" %>
<%@ page import="com.studentmanagement.model.StudentAssessment" %>
<%
    List<StudentAssessment> officialAssessments =
        (List<StudentAssessment>) request.getAttribute("officialAssessments");
    BigDecimal officialObtained = BigDecimal.ZERO;
    BigDecimal officialMaximum = BigDecimal.ZERO;
    if (officialAssessments != null) {
        for (StudentAssessment a : officialAssessments) {
            if (a.getMarksObtained() != null && a.getMaxMarks() != null
                    && a.getMaxMarks().compareTo(BigDecimal.ZERO) > 0) {
                officialObtained = officialObtained.add(a.getMarksObtained());
                officialMaximum = officialMaximum.add(a.getMaxMarks());
            }
        }
    }
    BigDecimal officialAverage = officialMaximum.signum() > 0
        ? officialObtained.multiply(new BigDecimal("100")).divide(officialMaximum, 2, RoundingMode.HALF_UP)
        : BigDecimal.ZERO;
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>What-If Grade Simulator | EduSphere</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
.sim-card{background:#fff;padding:24px;margin-bottom:22px;border:1px solid #e5e7eb;border-radius:14px;box-shadow:0 3px 12px rgba(20,35,60,.04)}
.sim-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:16px}
.sim-stat{background:#f8fafc;border:1px solid #e2e8f0;border-radius:12px;padding:18px}
.sim-stat small{display:block;color:#64748b;margin-bottom:8px}.sim-stat strong{font-size:27px;color:#172033}
.sim-note{padding:14px 16px;background:#eff6ff;color:#1e40af;border-radius:10px;margin:14px 0}
.sim-safe{padding:14px 16px;background:#ecfdf5;color:#065f46;border-radius:10px;margin-bottom:18px}
.sim-table-wrap{overflow-x:auto}.sim-table{width:100%;border-collapse:collapse;min-width:520px}
.sim-table th,.sim-table td{padding:12px;border-bottom:1px solid #e5e7eb;text-align:left}
.sim-table th{background:#f8fafc;color:#475569}
.sim-input{width:100%;padding:10px;border:1px solid #cbd5e1;border-radius:8px;box-sizing:border-box}
.sim-actions{display:flex;gap:10px;flex-wrap:wrap;margin-top:16px}
.sim-result{font-size:25px;font-weight:700;color:#4338ca}.sim-muted{color:#64748b;font-size:13px}
.sim-remove{border:0;background:#fee2e2;color:#991b1b;padding:8px 11px;border-radius:7px;cursor:pointer}
@media(max-width:700px){.sim-card{padding:17px}}
</style>
</head>
<body>
<div class="app-layout">
<aside class="sidebar">
  <div class="brand"><div class="brand-icon">E</div><div><div class="brand-name">EduSphere</div><span class="brand-subtitle">STUDENT PORTAL</span></div></div>
  <div><p class="nav-label">STUDENT MENU</p><nav class="nav-menu">
    <a class="nav-link" href="${pageContext.request.contextPath}/student/dashboard"><span>🏠</span> Dashboard</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/student/attendance/history"><span>📅</span> My Attendance</a>
    <a class="nav-link" href="${pageContext.request.contextPath}/student/academic-progress"><span>📊</span> My Academic Progress</a>
    <a class="nav-link active" href="${pageContext.request.contextPath}/student/grade-simulator"><span>🧮</span> What-If Grade Simulator</a>
  </nav></div>
  <div class="sidebar-footer"><p>EduSphere Student Portal</p><form action="${pageContext.request.contextPath}/logout" method="post"><button type="submit" class="btn btn-danger">Logout</button></form></div>
</aside>
<main class="main-content">
<header class="topbar"><div><p class="breadcrumb">Student / What-If Grade Simulator</p><h1 class="page-title">What-If Grade Simulator</h1><p class="page-description">Experiment with possible future marks and see how they could affect your overall average.</p></div><div class="avatar">S</div></header>

<% if (request.getAttribute("errorMessage") != null) { %>
<section class="sim-card"><p><%= request.getAttribute("errorMessage") %></p></section>
<% } else { %>
<div class="sim-safe"><strong>Simulation only:</strong> Hypothetical marks stay in this browser page. They are never saved to your official academic records.</div>
<section class="sim-card">
<h2>Official academic baseline</h2><p class="sim-muted">Read-only figures from your existing official assessments.</p>
<div class="sim-grid">
<div class="sim-stat"><small>Official marks obtained</small><strong><%= officialObtained %></strong></div>
<div class="sim-stat"><small>Official maximum marks</small><strong><%= officialMaximum %></strong></div>
<div class="sim-stat"><small>Official average</small><strong><%= officialAverage %>%</strong></div>
</div>
<input type="hidden" id="officialObtained" value="<%= officialObtained.toPlainString() %>">
<input type="hidden" id="officialMaximum" value="<%= officialMaximum.toPlainString() %>">
</section>

<section class="sim-card">
<h2>1. Try hypothetical assessment marks</h2>
<p class="sim-muted">Add multiple possible future assessments. Each can have a different maximum mark.</p>
<div class="sim-table-wrap"><table class="sim-table">
<thead><tr><th>Assessment</th><th>Marks obtained</th><th>Maximum marks</th><th></th></tr></thead>
<tbody id="whatIfRows"><tr>
<td><input class="sim-input sim-name" value="Future assessment 1" aria-label="Assessment name"></td>
<td><input class="sim-input sim-marks" type="number" min="0" step="0.01" placeholder="e.g. 80"></td>
<td><input class="sim-input sim-max" type="number" min="0.01" step="0.01" value="100"></td>
<td><button type="button" class="sim-remove" onclick="removeWhatIfRow(this)">Remove</button></td>
</tr></tbody></table></div>
<div class="sim-actions"><button type="button" class="btn btn-primary" id="addWhatIf">+ Add assessment</button><button type="button" class="btn btn-danger" id="resetWhatIf">Reset simulation</button></div>
<div class="sim-note">Projected average = official marks plus hypothetical marks, divided by official maximum plus hypothetical maximum.</div>
<div class="sim-grid">
<div class="sim-stat"><small>Projected marks obtained</small><strong id="projectedObtained">—</strong></div>
<div class="sim-stat"><small>Projected maximum marks</small><strong id="projectedMaximum">—</strong></div>
<div class="sim-stat"><small>Projected overall average</small><strong class="sim-result" id="projectedAverage"><%= officialAverage %>%</strong></div>
</div><p id="simulationMessage" class="sim-muted" aria-live="polite">Enter hypothetical marks to see your projection.</p>
</section>

<section class="sim-card">
<h2>2. Target average calculator</h2>
<p class="sim-muted">Calculate the marks needed across your remaining assessments to reach a target overall average.</p>
<div class="sim-grid">
<div><label for="targetAverage">Target overall average (%)</label><input class="sim-input" id="targetAverage" type="number" min="0" max="100" step="0.01" placeholder="e.g. 85"></div>
<div><label for="remainingMaximum">Total maximum marks remaining</label><input class="sim-input" id="remainingMaximum" type="number" min="0.01" step="0.01" placeholder="e.g. 200"></div>
</div>
<div class="sim-actions"><button type="button" class="btn btn-primary" id="calculateTarget">Calculate required marks</button></div>
<p id="targetResult" class="sim-result" aria-live="polite">—</p><p id="targetExplanation" class="sim-muted"></p>
</section>
<% } %>
</main></div>

<script>
(function(){
 const officialObtained=Number(document.getElementById("officialObtained")?.value||0);
 const officialMaximum=Number(document.getElementById("officialMaximum")?.value||0);
 const rows=document.getElementById("whatIfRows"); if(!rows)return;
 const fmt=n=>Number(n).toFixed(2).replace(/\.00$/,"");
 function calculate(){
   let hypoObtained=0,hypoMaximum=0,count=0,invalid=false;
   rows.querySelectorAll("tr").forEach(row=>{
     const m=row.querySelector(".sim-marks").value.trim(), x=row.querySelector(".sim-max").value.trim();
     if(m==="")return;
     const marks=Number(m),max=Number(x);
     if(m===""||x===""||!Number.isFinite(marks)||!Number.isFinite(max)||max<=0||marks<0||marks>max){invalid=true;return;}
     hypoObtained+=marks;hypoMaximum+=max;count++;
   });
   const avgEl=document.getElementById("projectedAverage"),msg=document.getElementById("simulationMessage");
   if(invalid){avgEl.textContent="Check inputs";document.getElementById("projectedObtained").textContent="—";document.getElementById("projectedMaximum").textContent="—";msg.textContent="Marks must be between 0 and a positive maximum. Complete or clear each row.";return;}
   const obtained=officialObtained+hypoObtained,maximum=officialMaximum+hypoMaximum;
   document.getElementById("projectedObtained").textContent=fmt(obtained);
   document.getElementById("projectedMaximum").textContent=fmt(maximum);
   avgEl.textContent=fmt(maximum>0?obtained/maximum*100:0)+"%";
   msg.textContent=count+" hypothetical assessment(s) included. Official records remain unchanged.";
 }
 function addRow(){
   const tr=document.createElement("tr"),i=rows.querySelectorAll("tr").length+1;
   tr.innerHTML='<td><input class="sim-input sim-name" aria-label="Assessment name" value="Future assessment '+i+'"></td><td><input class="sim-input sim-marks" type="number" min="0" step="0.01" placeholder="e.g. 80"></td><td><input class="sim-input sim-max" type="number" min="0.01" step="0.01" value="100"></td><td><button type="button" class="sim-remove" onclick="removeWhatIfRow(this)">Remove</button></td>';
   rows.appendChild(tr);calculate();
 }
 window.removeWhatIfRow=function(button){button.closest("tr").remove();calculate();};
 document.getElementById("addWhatIf").addEventListener("click",addRow);
 document.getElementById("resetWhatIf").addEventListener("click",function(){
   rows.innerHTML="";addRow();
   document.getElementById("targetAverage").value="";
   document.getElementById("remainingMaximum").value="";
   document.getElementById("targetResult").textContent="—";
   document.getElementById("targetExplanation").textContent="";
   calculate();
 });
 rows.addEventListener("input",calculate);
 document.getElementById("calculateTarget").addEventListener("click",function(){
   const target=Number(document.getElementById("targetAverage").value);
   const remaining=Number(document.getElementById("remainingMaximum").value);
   const result=document.getElementById("targetResult"),explanation=document.getElementById("targetExplanation");
   if(!Number.isFinite(target)||target<0||target>100||!Number.isFinite(remaining)||remaining<=0){
     result.textContent="Enter a target from 0 to 100 and positive remaining maximum marks.";explanation.textContent="";return;
   }
   const required=target/100*(officialMaximum+remaining)-officialObtained;
   if(required<=0){result.textContent="0 marks required mathematically.";explanation.textContent="Your current official average already meets or exceeds this target.";}
   else if(required>remaining){result.textContent=fmt(required)+" / "+fmt(remaining)+" marks";explanation.textContent="This target is not achievable using the stated remaining maximum marks alone.";}
   else{result.textContent=fmt(required)+" / "+fmt(remaining)+" marks";explanation.textContent="You need approximately "+fmt(required/remaining*100)+"% across the remaining assessments.";}
 });
 calculate();
})();
</script>
</body>
</html>
