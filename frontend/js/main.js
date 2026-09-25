/**
 * Vijayraj Gems & Jewellery - Core Client-Side Interactions
 * Handles sidebar toggling, toast dismissals, and quick table filtering.
 * (No API calls, purely UI behavior)
 */

document.addEventListener('DOMContentLoaded', () => {
  // 1. Mobile Sidebar Toggle
  const menuToggle = document.getElementById('mobileMenuToggle');
  const sidebar = document.getElementById('appSidebar');
  if (menuToggle && sidebar) {
    menuToggle.addEventListener('click', () => {
      sidebar.classList.toggle('open');
    });

    // Close when clicking outside
    document.addEventListener('click', (e) => {
      if (sidebar.classList.contains('open') && !sidebar.contains(e.target) && !menuToggle.contains(e.target)) {
        sidebar.classList.remove('open');
      }
    });
  }

  // 2. Auto-dismiss Toast Flash Messages
  const toasts = document.querySelectorAll('.toast');
  toasts.forEach((toast) => {
    setTimeout(() => {
      toast.style.opacity = '0';
      toast.style.transform = 'translateX(100%)';
      setTimeout(() => toast.remove(), 300);
    }, 4500);
  });

  // 3. Sticky Landing Navbar on Scroll
  const landingNav = document.getElementById('landingNav');
  if (landingNav) {
    window.addEventListener('scroll', () => {
      if (window.scrollY > 50) {
        landingNav.classList.add('scrolled');
      } else {
        landingNav.classList.remove('scrolled');
      }
    });
  }

  // 4. Client-side Quick Table Search (if data-table-filter is present)
  const quickSearch = document.getElementById('tableQuickSearch');
  if (quickSearch) {
    const tableBody = document.querySelector('.data-table tbody');
    if (tableBody) {
      const rows = tableBody.querySelectorAll('tr');
      quickSearch.addEventListener('input', (e) => {
        const query = e.target.value.toLowerCase().trim();
        rows.forEach((row) => {
          const text = row.textContent.toLowerCase();
          row.style.display = text.includes(query) ? '' : 'none';
        });
      });
    }
  }

  // 5. Image Fallback Handler (Graceful SVG/color fallback if image missing)
  const allImages = document.querySelectorAll('img');
  allImages.forEach((img) => {
    img.addEventListener('error', function () {
      this.onerror = null;
      // Replace with subtle SVG geometric placeholder
      this.src = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='400' height='300' viewBox='0 0 400 300'%3E%3Crect width='400' height='300' fill='%231B2B44'/%3E%3Cpolygon points='200,80 260,150 200,220 140,150' fill='none' stroke='%23C9A24B' stroke-width='3'/%3E%3Ctext x='200' y='250' font-family='sans-serif' font-size='14' fill='%23C9A24B' text-anchor='middle'%3EVijayraj Jewellery%3C/text%3E%3C/svg%3E";
    });
  });

  // 6. Live Bullion & Diamond Spot Market Engine
  initLiveMarketTicker();

  // 7. Global Seamless Add-to-Cart Interceptor (Keeps page open, updates badge, shows luxury toast)
  document.addEventListener('submit', function (e) {
    const form = e.target;
    if (!form || !form.action || !form.action.includes('/cart/add')) return;

    const buyNowInput = form.querySelector('input[name="buy_now"]');
    if (buyNowInput && buyNowInput.value === '1') {
      return; // Proceed to checkout directly
    }

    e.preventDefault();

    const submitBtn = form.querySelector('button[type="submit"]');
    const originalText = submitBtn ? submitBtn.innerHTML : '';
    if (submitBtn) {
      submitBtn.disabled = true;
      submitBtn.innerHTML = 'Adding...';
    }

    const formData = new FormData(form);

    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })
    .then(res => {
      if (res.status === 401) {
        window.location.href = '/customer/login?next=' + encodeURIComponent(window.location.pathname);
        return null;
      }
      return res.json();
    })
    .then(data => {
      if (!data) return;
      if (data.success) {
        const badges = document.querySelectorAll('.nav-cart-badge, .cart-count-badge');
        badges.forEach(b => {
          b.textContent = data.cart_count;
          b.style.display = data.cart_count > 0 ? 'inline-flex' : 'none';
        });

        const cartBtns = document.querySelectorAll('.nav-cart-btn');
        cartBtns.forEach(btn => {
          if (!btn.querySelector('.nav-cart-badge') && data.cart_count > 0) {
            const newBadge = document.createElement('span');
            newBadge.className = 'nav-cart-badge';
            newBadge.textContent = data.cart_count;
            btn.appendChild(newBadge);
          }
        });

        showLuxuryCartToast(data.message || 'Jewellery piece added to your shopping cart.');
      } else if (data.message) {
        showLuxuryCartToast(data.message, 'warning');
      }
    })
    .catch(err => {
      console.error('Cart add error:', err);
      form.submit();
    })
    .finally(() => {
      if (submitBtn) {
        submitBtn.disabled = false;
        submitBtn.innerHTML = originalText;
      }
    });
  });
});

/**
 * Live Bullion & Diamond Spot Market Engine
 * Simulates real-time certified diamond, precious gemstone and fine setting spot market ticks
 */
function initLiveMarketTicker() {
  const tickerContainers = document.querySelectorAll('.live-rates-track, .market-board-grid');
  if (!tickerContainers.length) return;

  // 1. Base rates from embedded JSON or gemstone market defaults
  const baseRates = {
    'Solitaire Diamond (1ct VVS1 EF)': 85000.00,
    'Colombian Emerald (Panna)': 35000.00,
    'Burmese Ruby (Manik)': 42000.00,
    'Ceylon Sapphire (Neelam)': 38000.00,
    'Yellow Sapphire (Pukhraj)': 26000.00,
    'Natural Basra Pearl': 12000.00,
    'Natural Tanzanite': 22000.00,
    '18K Gold Setting (Mount)': 6120.00,
    'Pt950 Platinum Setting': 3630.00,
    '925 Sterling Silver Setting': 98.00
  };

  const scriptTag = document.getElementById('liveMarketRatesJson');
  if (scriptTag) {
    try {
      const parsed = JSON.parse(scriptTag.textContent);
      if (Array.isArray(parsed) && parsed.length > 0) {
        parsed.forEach(item => {
          if (item.metal && item.rate) {
            baseRates[item.metal] = parseFloat(item.rate);
          }
        });
      }
    } catch (e) {
      console.warn('Error reading embedded market rates:', e);
    }
  }

  // 2. Restore or initialize state in sessionStorage for smooth session continuity
  let marketState = {};
  const stored = sessionStorage.getItem('vj_live_market_state');
  if (stored) {
    try {
      marketState = JSON.parse(stored);
      // Clean up legacy bullion keys if present
      delete marketState['Gold 24K'];
      delete marketState['Gold 22K'];
      delete marketState['Silver'];
      delete marketState['Platinum'];
      delete marketState['Diamond'];
    } catch (e) {}
  }

  Object.keys(baseRates).forEach(metal => {
    if (!marketState[metal]) {
      marketState[metal] = {
        open: baseRates[metal],
        current: baseRates[metal],
        high: baseRates[metal],
        low: baseRates[metal]
      };
    } else {
      marketState[metal].open = baseRates[metal];
    }
  });

  function formatInr(val) {
    if (isNaN(val)) return '₹0.00';
    return '₹' + Number(val).toLocaleString('en-IN', {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2
    });
  }

  function renderMarketDOM(tickedMetal = null, isUp = true) {
    Object.keys(marketState).forEach(metal => {
      const data = marketState[metal];
      const diff = data.current - data.open;
      const pct = (diff / data.open) * 100;
      const sign = diff >= 0 ? '+' : '';
      const arrow = diff >= 0 ? '▲' : '▼';
      const formattedRate = formatInr(data.current);

      // Update rate values across all matching elements
      const valElements = document.querySelectorAll(`.rate-val[data-metal="${metal}"]`);
      valElements.forEach(el => {
        el.textContent = formattedRate;
        if (metal === tickedMetal) {
          el.classList.remove('rate-tick-up', 'rate-tick-down');
          void el.offsetWidth; // trigger reflow
          el.classList.add(isUp ? 'rate-tick-up' : 'rate-tick-down');
          setTimeout(() => el.classList.remove('rate-tick-up', 'rate-tick-down'), 1400);
        }
      });

      // Update change pills
      const pillElements = document.querySelectorAll(`.rate-change-pill[data-metal="${metal}"]`);
      pillElements.forEach(el => {
        el.textContent = `${arrow} ${sign}${pct.toFixed(2)}%`;
        el.className = `rate-change-pill ${diff >= 0 ? 'up' : 'down'}`;
      });

      // Update day high / low
      const highEls = document.querySelectorAll(`.day-high[data-metal="${metal}"]`);
      highEls.forEach(el => el.textContent = formatInr(data.high));

      const lowEls = document.querySelectorAll(`.day-low[data-metal="${metal}"]`);
      lowEls.forEach(el => el.textContent = formatInr(data.low));
    });

    // Update timestamp clock
    const clockEl = document.getElementById('liveTickerClock');
    if (clockEl) {
      const now = new Date();
      clockEl.textContent = `Live Spot Market • ${now.toLocaleTimeString('en-IN')} IST`;
    }

    try {
      sessionStorage.setItem('vj_live_market_state', JSON.stringify(marketState));
    } catch (e) {}
  }

  // Initial render
  renderMarketDOM();

  // 3. Realistic Real-Time Market Tick Loop (every 3 seconds)
  const metalsList = Object.keys(marketState);
  setInterval(() => {
    // Pick 1 to 2 random metals to tick
    const countToTick = Math.random() > 0.4 ? 1 : 2;
    for (let i = 0; i < countToTick; i++) {
      const metal = metalsList[Math.floor(Math.random() * metalsList.length)];
      const data = marketState[metal];
      if (!data) continue;

      // Realistic tick variation (±0.02% to ±0.06%)
      const factor = (Math.random() - 0.485) * 0.0008;
      let newPrice = data.current + (data.open * factor);

      // Constrain within daily realistic trading bands (±1.5% of open)
      const maxBand = data.open * 1.015;
      const minBand = data.open * 0.985;
      if (newPrice > maxBand) newPrice = maxBand;
      if (newPrice < minBand) newPrice = minBand;

      const isUp = newPrice >= data.current;
      data.current = Math.round(newPrice * 100) / 100;

      if (data.current > data.high) data.high = data.current;
      if (data.current < data.low) data.low = data.current;

      renderMarketDOM(metal, isUp);
    }
  }, 3200);
}

/** Global Toast Dismiss */
function closeToast(btn) {
  const toast = btn.closest('.toast');
  if (toast) {
    toast.remove();
  }
}

/** Global Delete Confirmation */
function confirmAction(message) {
  return confirm(message || 'Are you sure you want to perform this action? This cannot be undone.');
}

/** Luxury Cart Floating Toast Notification */
function showLuxuryCartToast(message, type = 'success') {
  let toastContainer = document.querySelector('.toast-container');
  if (!toastContainer) {
    toastContainer = document.createElement('div');
    toastContainer.className = 'toast-container';
    toastContainer.style.position = 'fixed';
    toastContainer.style.top = '1.5rem';
    toastContainer.style.right = '1.5rem';
    toastContainer.style.zIndex = '99999';
    toastContainer.style.display = 'flex';
    toastContainer.style.flexDirection = 'column';
    toastContainer.style.gap = '0.75rem';
    toastContainer.style.maxWidth = '380px';
    document.body.appendChild(toastContainer);
  }

  const toast = document.createElement('div');
  toast.className = `toast toast-${type}`;
  toast.style.background = '#0F1B2D';
  toast.style.color = '#FAF7F2';
  toast.style.border = '1px solid #C9A24B';
  toast.style.borderRadius = '8px';
  toast.style.padding = '0.85rem 1.25rem';
  toast.style.boxShadow = '0 8px 24px rgba(15,27,45,0.25)';
  toast.style.display = 'flex';
  toast.style.alignItems = 'center';
  toast.style.justifyContent = 'space-between';
  toast.style.gap = '0.75rem';
  toast.style.fontSize = '0.88rem';
  toast.style.transition = 'all 0.3s ease';

  toast.innerHTML = `
    <div style="display:flex; align-items:center; gap:8px;">
      <span style="color:#C9A24B; font-size:1.1rem;">💎</span>
      <span>${message}</span>
    </div>
    <button type="button" onclick="this.parentElement.remove()" style="background:none; border:none; color:#C9A24B; cursor:pointer; font-size:1.1rem; padding:0 4px;">&times;</button>
  `;

  toastContainer.appendChild(toast);

  setTimeout(() => {
    toast.style.opacity = '0';
    toast.style.transform = 'translateX(100%)';
    setTimeout(() => toast.remove(), 300);
  }, 4000);
}
