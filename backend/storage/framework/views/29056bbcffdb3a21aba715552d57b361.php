<?php if(session('info')): ?>
    <div class="alert alert-info alert-dismissible fade show" role="alert">
        <?php echo e(session('info')); ?>

        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
<?php endif; ?>
<?php /**PATH E:\KULIAH\SEMESTER 4\PA2\ProyekAkhir2\backend\resources\views/layouts/partials/alerts.blade.php ENDPATH**/ ?>