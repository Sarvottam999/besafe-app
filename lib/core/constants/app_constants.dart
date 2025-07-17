// core/constants/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'BeSafe';
  static const String breachApiUrl = 'https://haveibeenpwned.com/api/v3/breachedaccount/';
  static const int scanInterval = 24; // hours
  
  // UI Constants
  static const String welcomeTitle = 'Welcome to';
  static const String selectionSubtitle = 'Let’s check if your email is safe online.';
  static const String chooseDeviceEmail = 'Choose from my device';
  static const String enterManualEmail = 'Enter another email manually';
  static const String monitorToggleText = 'Monitor this email';
  static const String monitorDescription = 'We\'ll scan this daily and notify you if a breach is found.';

// ℹ️ We check if your email was part of any past leaks on websites like Facebook, LinkedIn, etc.  
// 🛡️ Your email is not stored anywhere. 
  // static const String emailIcon = 'assets/email_icon.svg';
  // static const String scanIcon = 'assets/scan_icon.svg';
  // static const String monitorIcon = 'assets/monitor_icon.svg';
  // static const String notificationIcon = 'assets/notification_icon.svg';
  static const Color goldColor = Color(0xFFFFD700);
  static const Color purple = Color(0xFF6C5CE7);
  static const Color darkPurple = Color(0xFF1A1A2E);


  // images 
  static const String svgAppLogo =  '''<svg width="2183" height="1663" viewBox="0 0 2183 1663" fill="none" xmlns="http://www.w3.org/2000/svg">
<ellipse cx="1640.5" cy="1161" rx="510.5" ry="502" fill="#198CFF"/>
<path d="M1921.66 942.26L1651.71 865.053C1646.68 863.621 1641.31 863.621 1636.28 865.053L1366.35 942.26C1355.13 945.476 1347.47 955.25 1347.47 966.304C1347.47 1116.62 1351.64 1248.7 1402.89 1342.62C1453.77 1435.98 1537.37 1465.42 1611.12 1491.4C1618.94 1494.14 1626.73 1496.9 1634.44 1499.72C1637.5 1500.82 1640.75 1501.38 1643.99 1501.38C1647.24 1501.38 1650.48 1500.82 1653.54 1499.72C1661.23 1496.93 1668.99 1494.17 1676.81 1491.43C1750.59 1465.45 1834.21 1436 1885.12 1342.62C1936.37 1248.73 1940.54 1116.65 1940.54 966.304C1940.54 955.25 1932.89 945.476 1921.66 942.26ZM1837.86 1319.6C1796.34 1395.7 1729.29 1419.34 1658.25 1444.34C1653.46 1446 1648.73 1447.71 1643.99 1449.37C1639.23 1447.69 1634.5 1446 1629.68 1444.32C1558.7 1419.32 1491.65 1395.68 1450.16 1319.6C1406.38 1239.35 1401.06 1120.84 1400.69 984.972L1643.99 915.352L1887.32 984.972C1886.93 1120.84 1881.63 1239.33 1837.86 1319.6ZM1861.77 688.38V158.207C1861.77 70.9761 1786.63 0 1694.29 0H167.479C75.1355 0 0 70.9761 0 158.207V1148.25C0 1235.49 75.1355 1306.46 167.479 1306.46H1129.8C1198.6 1512.88 1403.05 1663 1643.99 1663C1941.21 1663 2183 1434.62 2183 1153.88C2183 950.627 2057.38 769.958 1861.77 688.38ZM1115.97 1256.21H167.479C104.472 1256.21 53.1933 1207.77 53.1933 1148.25V158.207C53.1933 98.6881 104.472 50.2485 167.479 50.2485H1694.29C1757.29 50.2485 1808.57 98.6881 1808.57 158.207V669.361C1755.59 653.281 1700.48 644.764 1643.99 644.764C1519.68 644.764 1404.38 685.264 1312.39 753.2L1208.53 661.145L1662.56 242.851C1673.09 233.153 1673.28 217.25 1663.04 207.325C1652.8 197.401 1635.93 197.225 1625.43 206.873L944.234 834.452L235.965 206.521C225.247 197.05 208.411 197.502 198.358 207.627C188.304 217.752 188.836 233.656 199.528 243.153L653.214 645.342L199.182 1063.64C188.65 1073.33 188.464 1089.24 198.704 1099.16C203.916 1104.21 210.832 1106.75 217.747 1106.75C224.449 1106.75 231.152 1104.36 236.311 1099.61L692.018 679.762L926.388 887.54C931.495 892.087 938.037 894.348 944.58 894.348C951.282 894.348 957.985 891.962 963.145 887.213L1170.41 696.269L1271.96 786.289C1184.83 864.852 1124.88 970.626 1109.13 1090.67C1106.39 1111.45 1105.01 1132.75 1105.01 1153.93C1105.04 1188.96 1108.81 1223.15 1115.97 1256.21ZM1643.99 1612.78C1376.14 1612.78 1158.2 1406.93 1158.2 1153.91C1158.2 1134.79 1159.45 1115.59 1161.93 1096.85C1191.98 867.767 1399.22 695.012 1643.99 695.012C1706.68 695.012 1767.64 706.092 1825.22 728.001C2010.23 798.298 2129.78 965.5 2129.78 1153.93C2129.81 1406.91 1911.87 1612.78 1643.99 1612.78Z" fill="white"/>
</svg>
''';

  static const String premiumIcon = '''
<svg xmlns="http://www.w3.org/2000/svg" height="24px" viewBox="0 -960 960 960" width="24px" fill="#e3e3e3"><path d="M200-160v-80h560v80H200Zm0-140-51-321q-2 0-4.5.5t-4.5.5q-25 0-42.5-17.5T80-680q0-25 17.5-42.5T140-740q25 0 42.5 17.5T200-680q0 7-1.5 13t-3.5 11l125 56 125-171q-11-8-18-21t-7-28q0-25 17.5-42.5T480-880q25 0 42.5 17.5T540-820q0 15-7 28t-18 21l125 171 125-56q-2-5-3.5-11t-1.5-13q0-25 17.5-42.5T820-740q25 0 42.5 17.5T880-680q0 25-17.5 42.5T820-620q-2 0-4.5-.5t-4.5-.5l-51 321H200Zm68-80h424l26-167-105 46-133-183-133 183-105-46 26 167Zm212 0Z"/></svg>
''';

   static const String onboradingBg = 
  '''
<svg width="780" height="780" viewBox="0 0 780 780" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_11_8)">
<g filter="url(#filter0_f_11_8)">
<path d="M778 584.975C778 604.62 628.501 722 476.896 722C325.291 722 5 361.527 5 233.5C27.8754 109.244 626.394 30 777.999 30C777.999 222.522 778 455.317 778 584.975Z" fill="url(#paint0_linear_11_8)"/>
</g>
<g filter="url(#filter1_d_11_8)">
<path d="M779.5 592C779.5 592 481 849.5 313.198 619.382" stroke="url(#paint1_linear_11_8)" stroke-width="7"/>
</g>
</g>
<defs>
<filter id="filter0_f_11_8" x="-95" y="-70" width="973" height="892" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feBlend mode="normal" in="SourceGraphic" in2="BackgroundImageFix" result="shape"/>
<feGaussianBlur stdDeviation="0" result="effect1_foregroundBlur_11_8"/>
</filter>
<filter id="filter1_d_11_8" x="306.37" y="589.351" width="479.411" height="137.159" filterUnits="userSpaceOnUse" color-interpolation-filters="sRGB">
<feFlood flood-opacity="0" result="BackgroundImageFix"/>
<feColorMatrix in="SourceAlpha" type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 127 0" result="hardAlpha"/>
<feOffset dy="4"/>
<feGaussianBlur stdDeviation="2"/>
<feComposite in2="hardAlpha" operator="out"/>
<feColorMatrix type="matrix" values="0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0.25 0"/>
<feBlend mode="normal" in2="BackgroundImageFix" result="effect1_dropShadow_11_8"/>
<feBlend mode="normal" in="SourceGraphic" in2="effect1_dropShadow_11_8" result="shape"/>
</filter>
<linearGradient id="paint0_linear_11_8" x1="344" y1="124" x2="633.322" y2="676.358" gradientUnits="userSpaceOnUse">
<stop stop-color="#2D1B69"/>
<stop offset="0.233342" stop-color="#453D82"/>
<stop offset="0.506417" stop-color="#6E71EC"/>
<stop offset="0.726458" stop-color="#6D63E9"/>
<stop offset="0.861769" stop-color="#4D40A9"/>
<stop offset="1" stop-color="#0B0727"/>
</linearGradient>
<linearGradient id="paint1_linear_11_8" x1="378.206" y1="662.852" x2="768.548" y2="528.426" gradientUnits="userSpaceOnUse">
<stop stop-color="#6C5CE7"/>
<stop offset="0.374175" stop-color="#7082F1"/>
<stop offset="0.75" stop-color="#75BAFF"/>
<stop offset="1" stop-color="#74B9FF"/>
</linearGradient>
<clipPath id="clip0_11_8">
<rect width="780" height="780" fill="white"/>
</clipPath>
</defs>
</svg>


''';





}