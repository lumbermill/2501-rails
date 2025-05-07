// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// Force to add confirm dialog to danger(red) button
document.addEventListener("turbo:load", function() {
    for (const elm of document.getElementsByClassName("btn-danger")) {
        elm.addEventListener("click", function(event) {
            var confirmed = confirm("本当に削除しますか?");
            if (!confirmed) {
              event.preventDefault();
            }
        });
        console.log("Added confirm dialog to:"+elm);
    }
});

import "trix"
import "@rails/actiontext"
