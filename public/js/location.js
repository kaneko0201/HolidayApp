document.addEventListener("DOMContentLoaded", function() {
  initLocationButton();
});

function initLocationButton() {
  const locationButton = document.getElementById("get-location-btn");
  const locationInput = document.getElementById("location-input");

  if (!locationButton) return;

  if (!locationButton.dataset.listenerAdded) {
    locationButton.addEventListener("click", handleLocationClick);
    locationButton.dataset.listenerAdded = "true"; 
  }

  function handleLocationClick(event) {
    event.preventDefault();
    locationButton.textContent = "取得中...";
    locationButton.disabled = true;

    if ("geolocation" in navigator) {
      navigator.geolocation.getCurrentPosition(
        function (position) {
          const latitude = position.coords.latitude;
          const longitude = position.coords.longitude;
          sendLocationToServer(latitude, longitude);
        },
        function (error) {
          console.error("位置情報の取得に失敗しました:", error.message);
          alert("位置情報の取得に失敗しました。");
          resetButton();
        }
      );
    } else {
      console.error("このブラウザは Geolocation API をサポートしていません。");
      resetButton();
    }
  }

  function sendLocationToServer(latitude, longitude) {
    fetch("/homes/update", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ latitude, longitude }),
    })
      .then((response) => response.json())
      .then((data) => {
        console.log("サーバーのレスポンス:", data);
        if (data.address) {
          locationInput.value = data.address;
        }
        resetButton();
      })
      .catch((error) => {
        console.error("エラー:", error);
        resetButton();
      });
  }

  function resetButton() {
    locationButton.textContent = "現在地を取得";
    locationButton.disabled = false;
  }
}
