package com.example.mi_que

import android.animation.AnimatorSet
import android.animation.ValueAnimator
import android.os.Bundle
import android.view.animation.AnticipateInterpolator
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {

        splashScreen.setOnExitAnimationListener { view ->
            view.iconView?.let { icon ->
                // set an animator that goes from height to 0, it will use AnticipateInterpolator
                // set at the bottom of this code
                val animator = ValueAnimator.ofInt(icon.height, 0).setDuration(2000)
                // update the icon height and width every time the animator value change
                animator.addUpdateListener {
                    val value = it.animatedValue as Int
                    icon.layoutParams.width = value
                    icon.layoutParams.height = value
                    icon.requestLayout()
                    if (value == 0) {
                        view.remove()
                    }
                }
                val animationSet = AnimatorSet()
                animationSet.interpolator = AnticipateInterpolator()
                // Default tension of AnticipateInterpolator is 2,
                // this means that the animation will increase first the size of the icon a little
                // bit and then decrease
                animationSet.play(animator)
                animationSet.start() // Launch the animation
            }
        }
        // Llama al método original de FlutterActivity
        super.onCreate(savedInstanceState)
    }
}
