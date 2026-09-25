/**
 * Vijayraj Gems & Jewellery - Reports & Analytics Visualizer
 * Reads pre-rendered JSON payload from <script> tag and renders Chart.js charts.
 */

document.addEventListener('DOMContentLoaded', () => {
  // Check if Chart.js is loaded
  if (typeof Chart === 'undefined') return;

  const chartDataEl = document.getElementById('reportsChartData') || document.getElementById('salesChartData');
  if (!chartDataEl) return;

  let data = {};
  try {
    data = JSON.parse(chartDataEl.textContent);
  } catch (e) {
    console.error('Failed to parse reports chart data', e);
    return;
  }

  // Common luxury theme options
  const navyColor = '#0F1B2D';
  const goldColor = '#C9A24B';
  const lightGold = '#E8D5A7';
  const slateColor = '#1B2B44';
  const paleGrey = '#E7E1D6';

  // 1. Monthly Revenue Chart (Bar / Line)
  const salesCanvas = document.getElementById('salesTrendChart');
  if (salesCanvas && data.months && (data.revenues || data.monthly_revenue)) {
    const revenues = data.revenues || data.monthly_revenue;
    new Chart(salesCanvas, {
      type: 'line',
      data: {
        labels: data.months,
        datasets: [{
          label: 'Revenue (₹)',
          data: revenues,
          borderColor: goldColor,
          backgroundColor: 'rgba(201, 162, 75, 0.12)',
          borderWidth: 2.5,
          tension: 0.35,
          fill: true,
          pointBackgroundColor: goldColor,
          pointBorderColor: '#FFFFFF',
          pointBorderWidth: 2,
          pointRadius: 4,
          pointHoverRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                return 'Revenue: ₹' + Number(context.raw).toLocaleString('en-IN');
              }
            }
          }
        },
        scales: {
          x: {
            grid: { display: false },
            ticks: { color: '#6B7280', font: { family: 'Inter', size: 11 } }
          },
          y: {
            grid: { color: paleGrey },
            ticks: {
              color: '#6B7280',
              font: { family: 'Inter', size: 11 },
              callback: function(val) {
                return '₹' + (val >= 100000 ? (val / 100000).toFixed(1) + 'L' : val.toLocaleString('en-IN'));
              }
            }
          }
        }
      }
    });
  }

  // 2. Sales by Category (Doughnut Chart)
  const categoryCanvas = document.getElementById('categoryPieChart');
  if (categoryCanvas && data.categories && (data.cat_revenues || data.category_revenue)) {
    const catRevenues = data.cat_revenues || data.category_revenue;
    new Chart(categoryCanvas, {
      type: 'doughnut',
      data: {
        labels: data.categories,
        datasets: [{
          data: catRevenues,
          backgroundColor: [
            '#C9A24B', // Gold
            '#A0AEC0', // Silver
            '#4299E1', // Diamond
            '#718096', // Platinum
            '#ED8936'  // Gems
          ],
          borderWidth: 2,
          borderColor: '#FFFFFF'
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            position: 'bottom',
            labels: { font: { family: 'Inter', size: 11 }, color: '#1E2430', boxWidth: 12 }
          },
          tooltip: {
            callbacks: {
              label: function(context) {
                return context.label + ': ₹' + Number(context.raw).toLocaleString('en-IN');
              }
            }
          }
        },
        cutout: '68%'
      }
    });
  }

  // 3. Sales by Payment Mode (Bar Chart)
  const paymentCanvas = document.getElementById('paymentModeChart');
  if (paymentCanvas && data.payments && data.payment_revenue) {
    new Chart(paymentCanvas, {
      type: 'bar',
      data: {
        labels: data.payments,
        datasets: [{
          label: 'Total Turnover',
          data: data.payment_revenue,
          backgroundColor: [navyColor, goldColor, slateColor],
          borderRadius: 6
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            callbacks: {
              label: function(context) {
                return 'Turnover: ₹' + Number(context.raw).toLocaleString('en-IN');
              }
            }
          }
        },
        scales: {
          x: { grid: { display: false } },
          y: {
            grid: { color: paleGrey },
            ticks: {
              callback: function(val) {
                return '₹' + (val >= 100000 ? (val / 100000).toFixed(1) + 'L' : val.toLocaleString('en-IN'));
              }
            }
          }
        }
      }
    });
  }
});
