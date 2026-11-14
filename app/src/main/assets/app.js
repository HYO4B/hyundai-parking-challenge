(() => {
  'use strict';
  const input = document.querySelector('#destination');
  const parking = document.querySelector('#parking-result');
  const empty = document.querySelector('#empty-state');
  const fee = document.querySelector('#fee-calculated');
  const durationLabel = document.querySelector('#duration-label');
  const compareDuration = document.querySelector('#compare-duration');
  const referenceFee = document.querySelector('#reference-fee');
  const compareResult = document.querySelector('#compare-result');
  const format = amount => new Intl.NumberFormat('ko-KR').format(amount);
  const durationName = minutes => minutes === 30 ? '30분' : `${minutes / 60}시간`;
  function search() {
    const query = input.value.replace(/\s/g, '').toLowerCase();
    const terms = ['뱅뱅사거리', '언주초교', '언주초교공영주차장', '남부순환로363길19'];
    const found = query.length > 0 && terms.some(term => query.includes(term) || term.includes(query));
    parking.hidden = !found;
    empty.hidden = found;
  }
  document.querySelector('#search-form').addEventListener('submit', event => { event.preventDefault(); search(); });
  document.querySelector('#reset-search').addEventListener('click', () => { input.value = '뱅뱅사거리'; search(); });
  document.querySelectorAll('[data-minutes]').forEach(button => {
    button.setAttribute('aria-pressed', button.classList.contains('active') ? 'true' : 'false');
    button.addEventListener('click', () => {
      const minutes = Number(button.dataset.minutes);
      const publicFee = Math.ceil(minutes / 5) * 200;
      const nearbyFee = Math.ceil(minutes / 15) * 1000;
      const difference = nearbyFee - publicFee;
      document.querySelectorAll('[data-minutes]').forEach(item => { item.classList.remove('active'); item.setAttribute('aria-pressed', 'false'); });
      button.classList.add('active');
      button.setAttribute('aria-pressed', 'true');
      fee.innerHTML = `${format(publicFee)}<span>원</span>`;
      durationLabel.textContent = `${durationName(minutes)} 기준`;
      compareDuration.textContent = `${durationName(minutes)} 예상요금`;
      referenceFee.textContent = `${format(nearbyFee)}원`;
      const title = document.createElement('strong');
      const description = document.createElement('span');
      title.textContent = difference > 0 ? `${format(difference)}원 저렴` : difference < 0 ? `${format(-difference)}원 더 비쌈` : '요금 동일';
      description.textContent = '두 주차장의 과거 요금 비교';
      compareResult.replaceChildren(title, description);
    });
  });
})();
