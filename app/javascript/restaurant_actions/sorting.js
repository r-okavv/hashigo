document.addEventListener('turbo:load', function() {
  const sortOptions = document.getElementById('sort-options');

  if (sortOptions) {
    sortOptions.addEventListener('change', function() {
      const sortBy = this.value;
      const restaurantList = document.getElementById('restaurant-list');
      const restaurants = Array.from(restaurantList.querySelectorAll('[data-restaurant-container]'));

      let sortedRestaurants;

      switch (sortBy) {
        case 'rating':
          sortedRestaurants = restaurants.sort((a, b) => {
            const aCard = a.querySelector('.card');
            const bCard = b.querySelector('.card');
            const aValue = parseFloat(aCard.getAttribute('data-rating'));
            const bValue = parseFloat(bCard.getAttribute('data-rating'));
            return bValue - aValue; // 降順
          });
          break;
        case 'bookmarks':
          sortedRestaurants = restaurants.sort((a, b) => {
            const aCard = a.querySelector('.card');
            const bCard = b.querySelector('.card');
            const aValue = parseFloat(aCard.getAttribute('data-bookmarks'));
            const bValue = parseFloat(bCard.getAttribute('data-bookmarks'));
            return bValue - aValue; // 降順
          });
          break;

        default:
          sortedRestaurants = restaurants;
      }

      sortedRestaurants.forEach(restaurant => {
        restaurantList.appendChild(restaurant);
      });
    });
  }
});
