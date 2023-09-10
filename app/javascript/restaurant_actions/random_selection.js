document.addEventListener('turbo:load', function() {
  const selectCandidateButton = document.getElementById('select-candidate-button');
  const instruction = document.getElementById('instruction');
  const randomButton = document.getElementById('random-button');
  const checkboxes = document.querySelectorAll('.restaurant-checkbox');
  const checkAllContainer = document.getElementById('check-all-container'); 
  const checkAllCheckbox = document.getElementById('check-all');

  if (selectCandidateButton && instruction && randomButton && checkboxes.length > 0) {
    selectCandidateButton.addEventListener('click', function() {
      checkboxes.forEach(checkbox => {
        checkbox.classList.remove('hidden');
      });
      instruction.classList.remove('hidden');
      selectCandidateButton.classList.add('hidden');
      randomButton.classList.remove('hidden');
      checkAllContainer.classList.remove('hidden');
    });

    randomButton.addEventListener('click', function() {
      // 選択されたレストランのIDを取得
      const selectedIds = [];
      checkboxes.forEach(checkbox => {
        if (checkbox.checked) {
          selectedIds.push(checkbox.getAttribute('data-restaurant-id'));
        }
      });

      // IDのリストからランダムに1つ選択
      const randomId = selectedIds[Math.floor(Math.random() * selectedIds.length)];

      // 選択されたレストランの詳細ページにリダイレクト
      if (randomId) {
        window.location.href = `/restaurants/${randomId}`;
      } else {
        alert('レストランを選択してください');
      }
    });

    if (checkAllCheckbox) {
      checkAllCheckbox.addEventListener('change', function() {
        const isChecked = this.checked;
        checkboxes.forEach(checkbox => {
          checkbox.checked = isChecked;
        });
      });
    }
  }
});
